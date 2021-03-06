//
//  AddEditReportViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Protocol
/***********************************/
protocol AddEditReportDelegate: class {
    func reportCreatedOrModified()
}
/***********************************/
// MARK: - Properties
/***********************************/
class AddEditReportViewController: BaseViewControllerWithTableView {
    
    // UI
    var datePicker: UIDatePicker?
    var currentTextField: UITextField?
    var toolbar: UIToolbar?
    
    /*
     This differentiates whether an existing report needs to be edited, or  a new report needs to be added.
     The caller of this view controller needs to set this if edit flow is to be called.
     */
    var report: Report?
    
    weak var delegate: AddEditReportDelegate?
    
    let manager = AddAndEditReportManager()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension AddEditReportViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         The sequence in which the below methods are called is important to render the view correctly.
         The manager needs to know whether it is an adding expense or edit expense flow before the UI is rendered.
         The data is mapped accordingly.
         */
        
        if report != nil {
            manager.report = report!
        }
        updateUI()
        /*
         Since this is a dynamic form, we are making sure that the manager has a reference to all the cells before hand.
         The tableview does not provide any methods/properties to access all cells.
         Only the visible cells are maintained.
         In our case, we had to maintain state of all the cells before calling service.
         */
        manager.populateCells(fromController: self, delegate: self)
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension AddEditReportViewController {
    /**
     * The list of items to update on launch of the controller.
     */
    func updateUI() {
        navigationItem.title = Constants.ViewControllerTitles.addReport
        addBarButtonItems()
        initializeDatePicker()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    /**
     * Method to add bar button items.
     */
    func addBarButtonItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(rightBarButtonTapped(_:)))
        
        /*  If this is the only view controller, then we need to put a dismiss button.
         Since then this controller is being presented from dashboard.
         */
        if navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(leftBarButtonTapped(_:)))
        }
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
     * Since this controller is called as modal controller or navigation controller, we need to move out accordingly.
     */
    func navigateOutAfterReportCreation() {
        if navigationController?.viewControllers.count == 1 {
            // Navigate to the expense list.
            self.dismiss(animated: true, completion:nil)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddEditReportViewController {
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
            report != nil ? (callEditReportService()) : (callAddReportService())
        }
    }
    
    /**
     * Action for Cancel button.
     * Dismiss the controller.
     */
    func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissDatePicker(_ sender: UIBarButtonItem?) {
        currentTextField?.text = Utilities.convertDateToStringForDisplay((datePicker?.date)!)
        view.endEditing(true)
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension AddEditReportViewController {
    
    func callAddReportService() {
        
        showLoadingIndicator(disableUserInteraction: true)
        
        manager.addReport { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.hideLoadingIndicator(enableUserInteraction: true)
                self.delegate?.reportCreatedOrModified()
                self.navigateOutAfterReportCreation()
            case .failure(_, let message):
                // TODO: - Handle the empty table view screen.
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.hideLoadingIndicator(enableUserInteraction: true)
            }
        }
    }
    
    func callEditReportService() {
        
        showLoadingIndicator(disableUserInteraction: true)
        
        manager.updateReport { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.hideLoadingIndicator(enableUserInteraction: true)
                self.delegate?.reportCreatedOrModified()
                self.navigateOutAfterReportCreation()
            case .failure(_, let message):
                // TODO: - Handle the empty table view screen.
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.hideLoadingIndicator(enableUserInteraction: true)
            }
        }
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension AddEditReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getReportFields().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If the cell is already cached, then just return it from the cache.
        if let cell = manager.getExistingCells()[indexPath] {
            return cell
        }
        
        let identifier = manager.getTableViewCellIdentifier(forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomFieldBaseTableViewCell
        manager.formatCell(cell, forIndexPath: indexPath)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension AddEditReportViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell selected
        let cell = tableView.cellForRow(at: indexPath) as! CustomFieldBaseTableViewCell
        manager.performActionForSelectedCell(cell, forIndexPath: indexPath)
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension AddEditReportViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == CustomFieldType.date.rawValue {
            currentTextField = textField
            textField.inputView = datePicker
            textField.inputAccessoryView = toolbar
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == CustomFieldType.date.rawValue {
            dismissDatePicker(nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == CustomFieldType.date.rawValue {
            return false
        }
        textField.resignFirstResponder()
        return true
    }
}
