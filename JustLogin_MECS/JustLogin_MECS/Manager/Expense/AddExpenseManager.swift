//
//  AddExpenseManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseManager {
    
    var fields: [[ExpenseAndReportField]] = []
    
    var expenseService = ExpenseService()
    
    init() {
        updateFields()
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension AddExpenseManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getExpenseFields() -> [[ExpenseAndReportField]] {
        return fields
    }
    
    func getTableViewCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        let expenseField = (fields[indexPath.section])[indexPath.row]
        switch expenseField.fieldType {
        case ExpenseAndReportFieldType.category.rawValue:
            return Constants.CellIdentifiers.addExpenseTableViewCellCategory
        case ExpenseAndReportFieldType.date.rawValue:
            return Constants.CellIdentifiers.addExpenseTableViewCellDate
        case ExpenseAndReportFieldType.currencyAndAmount.rawValue:
            return Constants.CellIdentifiers.addExpenseTableViewCellCurrencyAndAmount
        case ExpenseAndReportFieldType.text.rawValue:
            return Constants.CellIdentifiers.addExpenseTableViewCellWithTextField
        case ExpenseAndReportFieldType.textView.rawValue:
            return Constants.CellIdentifiers.addExpenseTableViewCellWithTextView
        case ExpenseAndReportFieldType.imageSelection.rawValue:
            return Constants.CellIdentifiers.addExpenseTableViewCellWithImageSelection
        case ExpenseAndReportFieldType.dropdown.rawValue:
            return Constants.CellIdentifiers.addExpenseTableViewCellWithMultipleSelection
        default:
            return Constants.CellIdentifiers.addReportTableViewCellWithTextField
        }
    }
    
    func getPayload(fromTableView tableView: UITableView) -> [String: Any] {
        var payload = [String:Any]()
        
        var indexPath = IndexPath(item: 0, section: 0)
        
        for index in 0..<fields.count {
            indexPath.row = index
            let cell = tableView.cellForRow(at: indexPath) as! AddReportBaseTableViewCell
            //payload = payload.merged(with: cell.getPayload(withField: fields[index]))
        }
        return payload
    }
}
/***********************************/
// MARK: - UI updating
/***********************************/
extension AddExpenseManager {
    
    func formatCell(_ cell: AddExpenseBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let expenseField = (fields[indexPath.section])[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateView(withField: expenseField)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddExpenseManager {
    func performActionForSelectedCell(_ cell: AddExpenseBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = getExpenseFields()[indexPath.row]
//        if reportField.fieldType == ExpenseAndReportFieldType.text.rawValue ||
//            reportField.fieldType == ExpenseAndReportFieldType.textView.rawValue {
//            //cell.makeFirstResponder()
//        }
    }
    
    func validateInputs(forTableView tableView: UITableView) -> (success: Bool, errorMessage: String) {
        
        var indexPath = IndexPath(item: 0, section: 0)
        
        for index in 0..<fields.count {
            indexPath.row = index
            let cell = tableView.cellForRow(at: indexPath) as! AddExpenseBaseTableViewCell
            print(cell)
//            let validation = cell.validateInput(withField: fields[index])
//            if !validation.success {
//                return validation
//            }
        }
        return (true, Constants.General.emptyString)
    }
}
/***********************************/
// MARK: - Data manipulation
/***********************************/
extension AddExpenseManager {
    
    func updateFields() {
        // Mandatory fields
        var category = ExpenseAndReportField()
        category.name = "Category"
        category.fieldType = ExpenseAndReportFieldType.category.rawValue
        category.isMandatory = true
        category.isEnabled = true
        
        var date = ExpenseAndReportField()
        date.name = "Date"
        date.jsonParameter = Constants.RequestParameters.Expense.date
        date.fieldType = ExpenseAndReportFieldType.date.rawValue
        date.isMandatory = true
        date.isEnabled = true
        
        // By default choose the base currency id
        var currencyAndAmount = ExpenseAndReportField()
        currencyAndAmount.fieldType = ExpenseAndReportFieldType.currencyAndAmount.rawValue
        currencyAndAmount.isMandatory = true
        currencyAndAmount.isEnabled = true
        
        fields.append([category, date, currencyAndAmount])
        
        // Custom fields
        if let paymentModeField = Singleton.sharedInstance.organization?.expenseFields["paymentMode"], paymentModeField.isEnabled {
            fields.append([paymentModeField])
        }
        
        var sectionThree: [ExpenseAndReportField] = []
        if let merchantNameField = Singleton.sharedInstance.organization?.expenseFields["merchant"], merchantNameField.isEnabled {
            sectionThree.append(merchantNameField)
        }
        
        if let referenceNumberField = Singleton.sharedInstance.organization?.expenseFields["reference"], referenceNumberField.isEnabled {
            sectionThree.append(referenceNumberField)
        }
        
        if let locationField = Singleton.sharedInstance.organization?.expenseFields["location"], locationField.isEnabled {
            sectionThree.append(locationField)
        }
        
        if let descriptionField = Singleton.sharedInstance.organization?.expenseFields["description"], descriptionField.isEnabled {
            sectionThree.append(descriptionField)
        }
        
        fields.append(sectionThree)
        
        // Section 4
        var sectionFour: [ExpenseAndReportField] = []
        if let isBillableField = Singleton.sharedInstance.organization?.expenseFields["isBillable"], isBillableField.isEnabled {
            sectionFour.append(isBillableField)
        }
        
        if let customerField = Singleton.sharedInstance.organization?.expenseFields["customer"], customerField.isEnabled {
            sectionFour.append(customerField)
        }
        
        if let projectField = Singleton.sharedInstance.organization?.expenseFields["project"], projectField.isEnabled {
            sectionFour.append(projectField)
        }
        
        var addToReport = ExpenseAndReportField()
        addToReport.name = "Add to Report"
        addToReport.fieldType = ExpenseAndReportFieldType.dropdown.rawValue
        addToReport.isMandatory = false
        addToReport.isEnabled = true
        
        sectionFour.append(addToReport)
        
        // Add the section 4 elements to the complete fields
        fields.append(sectionFour)
        
        // TODO - Add the custom fields
        
        // Finally add the image block
        var attachImage = ExpenseAndReportField()
        attachImage.fieldType = ExpenseAndReportFieldType.imageSelection.rawValue
        attachImage.isMandatory = true
        attachImage.isEnabled = true
        
        fields.append([attachImage])
    }
}
