//
//  AddExpense.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Protocol
/***********************************/
protocol AddExpenseDelegate: class {
    func expenseCreated()
}
/***********************************/
// MARK: - Properties
/***********************************/
class AddExpenseViewController: BaseViewControllerWithTableView {
    
    var datePicker: UIDatePicker?
    var currentTextField: UITextField?
    var toolbar: UIToolbar?
    
    weak var delegate: AddExpenseDelegate?
    
    var dictCells: [IndexPath:AddExpenseBaseTableViewCell] = [:]
    
    let manager = AddExpenseManager()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension AddExpenseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.ViewControllerTitles.addExpense
        addBarButtonItems()
        initializeDatePicker()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        dictCells = getCellsFromTableView()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension AddExpenseViewController {
    /**
     * Method to add bar button items.
     */
    func addBarButtonItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    func initializeDatePicker() {
        toolbar = UIToolbar()
        toolbar?.barStyle = .default
        toolbar?.isTranslucent = true
        toolbar?.sizeToFit()
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 200))
        datePicker?.datePickerMode = UIDatePickerMode.date
        datePicker?.backgroundColor = UIColor.white
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissDatePicker(_:)))
        
        toolbar?.setItems([space, done], animated: true)
    }
    
    /**
     * Method to get all cells from the tableview.
     * This is done since all the cells are required for various validation excersies.
     */
    func getCellsFromTableView() -> [IndexPath : AddExpenseBaseTableViewCell] {
        var allCells: [IndexPath : AddExpenseBaseTableViewCell] = [:]
        for section in 0..<manager.getExpenseFields().count {
            for row in 0..<manager.getExpenseFields()[section].count {
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableView(tableView, cellForRowAt: indexPath) as! AddExpenseBaseTableViewCell
                allCells[indexPath] = cell
            }
        }
        return allCells
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddExpenseViewController {
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        let validation = manager.validateInputs(forTableViewCells: dictCells)
        if !validation.success {
            Utilities.showErrorAlert(withMessage: validation.errorMessage, onController: self)
        } else {
            callAddExpenseService()
        }
    }
    
    func dismissDatePicker(_ sender: UIBarButtonItem?) {
        currentTextField?.text = Utilities.convertDateToStringForDisplay((datePicker?.date)!)
        view.endEditing(true)
    }
}

/***********************************/
// MARK: - Service Call
/***********************************/
extension AddExpenseViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func callAddExpenseService() {
        
        showLoadingIndicator(disableUserInteraction: true)
        
        manager.addExpenseWithInput(fromTableViewCells:dictCells) { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.hideLoadingIndicator(enableUserInteraction: true)
                self.delegate?.expenseCreated()
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_, let message):
                 //TODO: - Handle the empty table view screen.
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.hideLoadingIndicator(enableUserInteraction: true)
            }
        }
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension AddExpenseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return manager.getExpenseFields().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getExpenseFields()[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If the cell is already cached, then just return it from the cache.
        if let cell = dictCells[indexPath] {
            return cell
        }
        
        // If it is not available in cache, then create or reuse the cell
        let identifier = manager.getTableViewCellIdentifier(forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddExpenseBaseTableViewCell
        manager.formatCell(cell, forIndexPath: indexPath)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension AddExpenseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell selected
        if manager.checkIfNavigationIsRequired(forIndexPath: indexPath) {
            self.view .endEditing(true)
            let controller = manager.getDetailsNavigationController(forIndexPath: indexPath, cells: dictCells, withDelegate: self)
            Utilities.pushControllerAndHideTabbar(fromController: self, toController: controller)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! AddExpenseBaseTableViewCell
            manager.performActionForSelectedCell(cell, forIndexPath: indexPath)
        }
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension AddExpenseViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == ExpenseAndReportFieldType.date.rawValue {
            currentTextField = textField
            textField.inputView = datePicker
            textField.inputAccessoryView = toolbar
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == ExpenseAndReportFieldType.date.rawValue {
            dismissDatePicker(nil)
        }
        
        // For the amount, round it to 2 decimal places
        if textField.tag == ExpenseAndReportFieldType.currencyAndAmount.rawValue {
            if let amount = Double(textField.text!) {
                textField.text = String(amount.roundTo(places: 2))
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == ExpenseAndReportFieldType.date.rawValue {
            return false
        }
        textField.resignFirstResponder()
        return true
    }
}
/***********************************/
// MARK: - ReviewSelectCategoryViewControllerDelegate
/***********************************/
extension AddExpenseViewController: ReviewSelectCategoryViewControllerDelegate {
    func categorySelected(_ category: Category) {
        manager.updateCellBasedAtLastSelectedIndex(fromCells: dictCells, withId: category.id, value: category.name)
    }
}
/***********************************/
// MARK: - ReviewSelectCurrencyViewControllerDelegate
/***********************************/
extension AddExpenseViewController: ReviewSelectCurrencyViewControllerDelegate {
    func currencySelected(_ currency: Currency) {
        manager.updateCellBasedAtLastSelectedIndex(fromCells: dictCells, withId: currency.id, value: currency.code)
    }
}
/***********************************/
// MARK: - ReviewSelectCurrencyViewControllerDelegate
/***********************************/
extension AddExpenseViewController: ReviewSelectReportViewControllerDelegate {
    func reportSelected(_ report: Report) {
        manager.updateCellBasedAtLastSelectedIndex(fromCells: dictCells, withId: report.id, value: report.title)
    }
}
