//
//  RecordReimbursementViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 21/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Protocol
/***********************************/
protocol RecordReimbursementDelegate: class {
    func reportReimbursed()
}
/***********************************/
// MARK: - Properties
/***********************************/
class RecordReimbursementViewController: BaseViewControllerWithTableView {
    
    let manager = RecordReimbursementManager()
    
    var datePicker: UIDatePicker?
    var currentTextField: UITextField?
    var toolbar: UIToolbar?
    
    weak var delegate: RecordReimbursementDelegate?
    
    var report: Report?
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension RecordReimbursementViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.report = report!
        updateUI()
        manager.populateCells(fromController: self)
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension RecordReimbursementViewController {
    func updateUI() {
        self.navigationItem.title = Constants.ViewControllerTitles.reimbursement
        
        addBarButtonItems()
        initializeDatePicker()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        // Make sure the manager has a reference to all the cell before hand
        manager.populateCells(fromController: self)
    }
    
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
}
/***********************************/
// MARK: - Actions
/***********************************/
extension RecordReimbursementViewController {
    
    /**
     * Action for Save button.
     * Do the validations before saving.
     */
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        let validation = manager.validateInputs()
        if !validation.success {
            Utilities.showErrorAlert(withMessage: validation.errorMessage, onController: self)
        } else {
            callRecordReimbursementService()
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
extension RecordReimbursementViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func callRecordReimbursementService() {
        
        showLoadingIndicator(disableUserInteraction: true)
        
        manager.recordReimbursement() { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.hideLoadingIndicator(enableUserInteraction: true)
                self.delegate?.reportReimbursed()
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
extension RecordReimbursementViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return manager.getFields().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getFields()[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If the cell is already cached, then just return it from the cache.
        if let cell = manager.getExistingCells()[indexPath] {
            return cell
        }
        
        // If it is not available in cache, then create or reuse the cell
        let identifier = manager.getTableViewCellIdentifier(forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomFieldBaseTableViewCell
        manager.formatCell(cell, forIndexPath: indexPath)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension RecordReimbursementViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 20 // TODO - Move to constant
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell selected
        if manager.checkIfNavigationIsRequired(forIndexPath: indexPath) {
            self.view .endEditing(true)
            let controller = manager.getDetailsNavigationController(forIndexPath: indexPath, withDelegate: self)
            Utilities.pushControllerAndHideTabbarForChildAndParent(fromController: self, toController: controller)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! CustomFieldBaseTableViewCell
            manager.performActionForSelectedCell(cell, forIndexPath: indexPath)
        }
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension RecordReimbursementViewController: UITextFieldDelegate {
    
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
