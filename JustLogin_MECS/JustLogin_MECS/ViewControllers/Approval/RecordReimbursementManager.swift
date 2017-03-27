//
//  RecordReimbursementManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 21/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
/**
 * Manager for RecordReimbursementViewController
 */
class RecordReimbursementManager {
    
    var report: Report = Report() {
        didSet {
            updateFieldValues(forReport: report)
        }
    }
    
    var approvalService: IApprovalService = ApprovalService()
    
    var fields: [[CustomField]] = []
    
    var lastSelectedNavigationIndex: IndexPath?
    
    var dictCells: [IndexPath:CustomFieldBaseTableViewCell] = [:]
    
    init() {
        updateFields()
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension RecordReimbursementManager {
    /**
     * Populate the cells from the table view.
     */
    func populateCells(fromController controller: RecordReimbursementViewController) {
        for section in 0..<fields.count {
            for row in 0..<fields[section].count {
                let indexPath = IndexPath(row: row, section: section)
                let cell = controller.tableView(controller.tableView, cellForRowAt: indexPath) as! CustomFieldBaseTableViewCell
                dictCells[indexPath] = cell
            }
        }
    }
    
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getFields() -> [[CustomField]] {
        return fields
    }
    
    /**
     * Get the existing cells that have already been populated before.
     */
    func getExistingCells() -> [IndexPath:CustomFieldBaseTableViewCell] {
        return dictCells
    }
    
    /**
     * Get the cell identifier for the indexPath.
     * This works based on the expense field type & accordingly the cell is displayed.
     */
    func getTableViewCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        let expenseField = (fields[indexPath.section])[indexPath.row]
        switch expenseField.fieldType {
        case CustomFieldType.label.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithLabelIdentifier
        case CustomFieldType.date.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellDateIdentifier
        case CustomFieldType.text.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextFieldIdentifier
        case CustomFieldType.textView.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextViewIdentifier
        case CustomFieldType.dropdown.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithMultipleSelectionIdentifier
        default:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextFieldIdentifier
        }
    }
}
/***********************************/
// MARK: - UI updating
/***********************************/
extension RecordReimbursementManager {
    
    func formatCell(_ cell: CustomFieldBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let expenseField = (fields[indexPath.section])[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateView(withField: expenseField)
    }
}
/***********************************/
// MARK: - Services
/***********************************/
extension RecordReimbursementManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func recordReimbursement(completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        var payload = getPayload()
        // The below values are not displayed on the screen, & thus need to be manually set.
        payload[Constants.RequestParameters.Report.reportId] = report.id
        payload[Constants.RequestParameters.Report.statusType] = ReportStatus.reimbursed.rawValue
        
        approvalService.processReport(payload: payload) { (result) in
            switch(result) {
            case .success(_):
                completionHandler(ManagerResponseToController.success())
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message))
            }
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension RecordReimbursementManager {
    /**
     * This will return true if we have to navigate to details screen for choosing a particular value.
     * Else return false.
     */
    func checkIfNavigationIsRequired(forIndexPath indexPath: IndexPath) -> Bool {
        let field = getFields()[indexPath.section][indexPath.row]
        
        // The below checks are done on the field TYPE.
        if field.fieldType == CustomFieldType.category.rawValue ||
            field.fieldType == CustomFieldType.currencyAndAmount.rawValue ||
            field.fieldType == CustomFieldType.dropdown.rawValue {
            return true
        }
        
        // The below checks are done on the JSON PARAMETER of the field.
        if field.jsonParameter == Constants.RequestParameters.Expense.reportId {
            return true
        }
        
        return false
    }
    
    func getDetailsNavigationController(forIndexPath indexPath: IndexPath, withDelegate delegate: RecordReimbursementViewController) -> UIViewController {
        let field = getFields()[indexPath.section][indexPath.row]
        
        // This will be used when setting the selected value.
        lastSelectedNavigationIndex = indexPath
        
        if field.fieldType == CustomFieldType.category.rawValue {
            return UIViewController()
        }
        
        if field.fieldType == CustomFieldType.currencyAndAmount.rawValue {
        }
        
        if field.jsonParameter == Constants.RequestParameters.Expense.reportId {
        }
        
        // TODO - Need to handle multiple choice for dropdown report fields
        return UIViewController()
    }
    /**
     * Sing the other cells are already being checked at the controller,
     */
    func performActionForSelectedCell(_ cell: CustomFieldBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        cell.makeFirstResponder()
    }
    
    func validateInputs() -> (success: Bool, errorMessage: String) {
        for (indexPath, cell) in dictCells {
            let validation = cell.validateInput(withField: fields[indexPath.section][indexPath.row])
            if !validation.success {
                return validation
            }
        }
        return (true, Constants.General.emptyString)
    }
    
    func updateCellBasedAtLastSelectedIndex(withId id: String, value: String) {
        if lastSelectedNavigationIndex != nil {
            let cell = dictCells[lastSelectedNavigationIndex!]
            cell?.updateView(withId: id, value: value)
        }
    }
}
/***********************************/
// MARK: - Data manipulation
/***********************************/
extension RecordReimbursementManager {
    
    func updateFields() {
        // Mandatory fields
        var amount = CustomField()
        amount.name = "Amount"
        amount.fieldType = CustomFieldType.label.rawValue
        amount.isMandatory = true
        amount.isEnabled = true
        
        var paidTo = CustomField()
        paidTo.name = "Paid To"
        paidTo.fieldType = CustomFieldType.label.rawValue
        paidTo.isMandatory = true
        paidTo.isEnabled = true
        
        fields.append([amount, paidTo])
        
        var date = CustomField()
        date.name = "Reimbursed Date"
        date.jsonParameter = "reimburseOn"
        date.fieldType = CustomFieldType.date.rawValue
        date.isMandatory = true
        date.isEnabled = true
        
        var paidThrough = CustomField()
        paidThrough.name = "Paid Through"
        paidThrough.fieldType = CustomFieldType.dropdown.rawValue
        paidThrough.jsonParameter = "paidThrough"
        paidThrough.dropdownValues = ["Petty Cash", "Undeposited Funds"]
        paidThrough.isMandatory = false
        paidThrough.isEnabled = true
        
        var notes = CustomField()
        notes.name = "Notes"
        notes.fieldType = CustomFieldType.textView.rawValue
        notes.jsonParameter = "notes"
        notes.isMandatory = false
        notes.isEnabled = true
        
        var referenceNumber = CustomField()
        referenceNumber.name = "Reference #"
        referenceNumber.fieldType = CustomFieldType.text.rawValue
        referenceNumber.jsonParameter = "referenceNumber"
        referenceNumber.isMandatory = false
        referenceNumber.isEnabled = true
        
        fields.append([date, paidThrough, notes, referenceNumber])
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension RecordReimbursementManager {
    /**
     * Get payload from all the cells of the table.
     */
    func getPayload() -> [String: Any] {
        var payload = [String:Any]()
        for (indexPath, cell) in dictCells {
            payload = payload.merged(with: cell.getPayload(withField: fields[indexPath.section][indexPath.row]))
        }
        return payload
    }
    
    func updateFieldValues(forReport report: Report) {
        
        for index in fields[0].indices {
            if fields[0][index].name == "Amount" {
                fields[0][index].values[Constants.CustomFieldKeys.value] = Utilities.getFormattedAmount(forReport: report)
            }
            
            if fields[0][index].name == "Paid To" {
                fields[0][index].values[Constants.CustomFieldKeys.value] = report.submitter.name
            }
        }
    }
}
