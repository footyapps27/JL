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
    
    var fields: [ExpenseAndReportField] = []
    
    var expenseService = ReportService()
    
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
    func getExpenseFields() -> [ExpenseAndReportField] {
        return fields
    }
    
    func getTableViewCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        let expenseField = fields[indexPath.row]
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
            payload = payload.merged(with: cell.getPayload(withField: fields[index]))
        }
        return payload
    }
}
/***********************************/
// MARK: - UI updating
/***********************************/
extension AddExpenseManager {
    
    func formatCell(_ cell: AddExpenseBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = fields[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //cell.updateView(withField: reportField)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddExpenseManager {
    func performActionForSelectedCell(_ cell: AddExpenseBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = getExpenseFields()[indexPath.row]
        if reportField.fieldType == ExpenseAndReportFieldType.text.rawValue ||
            reportField.fieldType == ExpenseAndReportFieldType.textView.rawValue {
            //cell.makeFirstResponder()
        }
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
        let currencyAndAmount = ExpenseAndReportField()
        date.fieldType = ExpenseAndReportFieldType.currencyAndAmount.rawValue
        date.isMandatory = true
        date.isEnabled = true
        
        fields.append(category)
        fields.append(date)
        fields.append(currencyAndAmount)
    }
}
