//
//  AddExpenseManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddEditExpenseManager {
    
    /*
        This differentiates whether an existing expense needs to be edited, or  a new expense needs to be added.
        The view controller needs to set this if edit flow is to be called.
        All the properties in the tableview will be updated based on the expense that is being set.
     */
    var expense: Expense? {
        didSet {
            if expense != nil {
                updateFieldValues(forExpense: expense!)
            }
        }
    }
    
    var fields: [[CustomField]] = []
    
    var expenseService: IExpenseService = ExpenseService()
    
    var lastSelectedNavigationIndex: IndexPath?
    
    var dictCells: [IndexPath:CustomFieldBaseTableViewCell] = [:]
    
    // On init, make sure that the fields are populated.
    init() {
        fields = AddEditExpenseDefaultConfiguration.getFields()
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension AddEditExpenseManager {
    
    func populateCells(fromController controller: BaseViewControllerWithTableView, delegate: UITableViewDataSource) {
        for section in 0..<fields.count {
            for row in 0..<fields[section].count {
                let indexPath = IndexPath(row: row, section: section)
                let cell = delegate.tableView(controller.tableView, cellForRowAt: indexPath) as! CustomFieldBaseTableViewCell
                dictCells[indexPath] = cell
            }
        }
    }
    
    /**
     * Get the existing cells that have already been populated before.
     */
    func getExistingCells() -> [IndexPath:CustomFieldBaseTableViewCell] {
        return dictCells
    }
    
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getExpenseFields() -> [[CustomField]] {
        return fields
    }
    
    /**
     * Get the cell identifier for the indexPath.
     * This works based on the expense field type & accordingly the cell is displayed.
     */
    func getTableViewCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        let expenseField = (fields[indexPath.section])[indexPath.row]
        switch expenseField.fieldType {
        case CustomFieldType.category.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellCategoryIdentifier
        case CustomFieldType.date.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellDateIdentifier
        case CustomFieldType.currencyAndAmount.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellCurrencyAndAmountIdentifier
        case CustomFieldType.text.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextFieldIdentifier
        case CustomFieldType.textView.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextViewIdentifier
        case CustomFieldType.imageSelection.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithImageSelectionIdentifier
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
extension AddEditExpenseManager {
    
    func formatCell(_ cell: CustomFieldBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let expenseField = (fields[indexPath.section])[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateView(withField: expenseField)
    }
}
/***********************************/
// MARK: - Services
/***********************************/
extension AddEditExpenseManager {
    /**
     * Create a new expense based on the inputs inserted by the user.
     */
    func addExpense(completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        let payload = getPayload()
        
        expenseService.create(payload: payload) { (result) in
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
    
    /**
     * Update an existing expense. 
     * This will make sure that the id of the expense will be added to the payload, before calling the service.
     */
    func updateExpense(completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        var payload = getPayload()
        payload[Constants.RequestParameters.Expense.expenseId] = expense!.id
        expenseService.update(payload: payload) { (result) in
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
extension AddEditExpenseManager {
    /**
     * This will return true if we have to navigate to details screen for choosing a particular value.
     * Else return false.
     */
    func checkIfNavigationIsRequired(forIndexPath indexPath: IndexPath) -> Bool {
        let expenseField = getExpenseFields()[indexPath.section][indexPath.row]
        
        // The below checks are done on the field TYPE.
        if expenseField.fieldType == CustomFieldType.category.rawValue ||
            expenseField.fieldType == CustomFieldType.currencyAndAmount.rawValue ||
            expenseField.fieldType == CustomFieldType.dropdown.rawValue {
            return true
        }
        
        // The below checks are done on the JSON PARAMETER of the field.
        if expenseField.jsonParameter == Constants.RequestParameters.Expense.reportId {
            return true
        }
        
        return false
    }
    
    func getDetailsNavigationController(forIndexPath indexPath: IndexPath, withDelegate delegate: BaseViewController) -> UIViewController {
        let expenseField = getExpenseFields()[indexPath.section][indexPath.row]
        
        // This will be used when setting the selected value.
        lastSelectedNavigationIndex = indexPath
        
        if expenseField.fieldType == CustomFieldType.category.rawValue {
            return getReviewSelectCategoryController(forIndexPath: indexPath, withDelegate: delegate)
        }
        
        if expenseField.fieldType == CustomFieldType.currencyAndAmount.rawValue {
            return getReviewSelectCurrencyController(forIndexPath: indexPath, withDelegate: delegate)
        }
        
        if expenseField.jsonParameter == Constants.RequestParameters.Expense.reportId {
            return getReviewSelectReportController(forIndexPath: indexPath, withDelegate: delegate)
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
// MARK: - Helpers
/***********************************/
extension AddEditExpenseManager {
    /**
     * This method will update the field value that is present in the existing report.
     * The value will be then passed to the cells, which will use them to update its view.
     */
    func updateFieldValues(forExpense expense: Expense) {
        for section in 0..<fields.count {
            for row in 0..<fields[section].count {
                // Category
                if fields[section][row].jsonParameter == Constants.RequestParameters.Expense.categoryId {
                    let categoryName = Singleton.sharedInstance.organization?.categories[expense.categoryId]?.name ?? Constants.General.emptyString
                    
                    fields[section][row].values[Constants.CustomFieldKeys.id] = expense.categoryId
                    fields[section][row].values[Constants.CustomFieldKeys.value] = categoryName
                    continue
                }
                
                // Date
                if fields[section][row].jsonParameter == Constants.RequestParameters.Expense.date {
                    if expense.date != nil {
                        fields[section][row].values[Constants.CustomFieldKeys.value] = Utilities.convertDateToStringForDisplay(expense.date!)
                        continue
                    }
                }
                
                // Currency and Amount
                if fields[section][row].fieldType == CustomFieldType.currencyAndAmount.rawValue {
                    let currencyCode = Singleton.sharedInstance.organization?.currencies[expense.currencyId]?.code ?? Constants.General.emptyString
                    fields[section][row].values[Constants.CustomFieldKeys.id] = expense.currencyId
                    fields[section][row].values[Constants.CustomFieldKeys.value] = currencyCode
                    fields[section][row].values[Constants.CustomFieldKeys.amount] = String(expense.amount)
                    continue
                }
                
                // Merchant Name
                if fields[section][row].jsonParameter == Constants.RequestParameters.CustomFieldJsonParameters.merchant {
                    fields[section][row].values[Constants.CustomFieldKeys.value] = expense.merchantName
                    continue
                }
                
                // Reference Number
                if fields[section][row].jsonParameter == Constants.RequestParameters.CustomFieldJsonParameters.reference {
                    fields[section][row].values[Constants.CustomFieldKeys.value] = expense.referenceNumber
                    continue
                }
                
                // Location
                if fields[section][row].jsonParameter == Constants.RequestParameters.CustomFieldJsonParameters.location {
                    fields[section][row].values[Constants.CustomFieldKeys.value] = expense.location
                    continue
                }
                
                // Description
                if fields[section][row].jsonParameter == Constants.RequestParameters.CustomFieldJsonParameters.description {
                    fields[section][row].values[Constants.CustomFieldKeys.value] = expense.description
                    continue
                }
                
                // Report Id
                if fields[section][row].jsonParameter == Constants.RequestParameters.Expense.reportId {
                    fields[section][row].values[Constants.CustomFieldKeys.id] = expense.reportId
                    fields[section][row].values[Constants.CustomFieldKeys.value] = expense.reportTitle
                    continue
                }
            }
        }
    }
    
    func getReviewSelectCategoryController(forIndexPath indexPath: IndexPath, withDelegate delegate: BaseViewController) -> ReviewSelectCategoryViewController {
        let controller = UIStoryboard(name: Constants.StoryboardIds.categoryStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Category.reviewSelectCategoryViewController) as! ReviewSelectCategoryViewController
        controller.delegate = delegate as? ReviewSelectCategoryViewControllerDelegate
        
        // Now check if it already has a preSelected value
        let cell = dictCells[indexPath]!
        
        let expenseField = getExpenseFields()[indexPath.section][indexPath.row]
        if cell.validateInput(withField: expenseField).success {
            let payload = cell.getPayload(withField: expenseField)
            if !payload.isEmpty {
                let preSelectedCategoryId = payload[Constants.RequestParameters.Expense.categoryId] as! String
                controller.preSelectedCategory = Singleton.sharedInstance.organization?.categories[preSelectedCategoryId]
            }
        }
        return controller
    }
    
    func getReviewSelectCurrencyController(forIndexPath indexPath: IndexPath, withDelegate delegate: BaseViewController) -> ReviewSelectCurrencyViewController {
        let controller = UIStoryboard(name: Constants.StoryboardIds.currencyStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Currency.reviewSelectCurrencyViewController) as! ReviewSelectCurrencyViewController
        controller.delegate = delegate as? ReviewSelectCurrencyViewControllerDelegate
        
        // Now check if it already has a preSelected value
        let cell = dictCells[indexPath]!
        
        let expenseField = getExpenseFields()[indexPath.section][indexPath.row]
        let payload = cell.getPayload(withField: expenseField)
        
        if !payload.isEmpty {
            let preSelectedCurrencyId = payload[Constants.RequestParameters.Expense.currencyId] as! String
            controller.preSelectedCurrency = Singleton.sharedInstance.organization?.currencies[preSelectedCurrencyId]
        }
        return controller
    }
    
    func getReviewSelectReportController(forIndexPath indexPath: IndexPath, withDelegate delegate: BaseViewController) -> ReviewSelectReportViewController {
        let controller = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Report.reviewSelectReportViewController) as! ReviewSelectReportViewController
        controller.delegate = delegate as? ReviewSelectReportViewControllerDelegate
        
        // Now check if it already has a preSelected value
        let cell = dictCells[indexPath]!
        
        let expenseField = getExpenseFields()[indexPath.section][indexPath.row]
        
        if cell.validateInput(withField: expenseField).success {
            let payload = cell.getPayload(withField: expenseField)
            if !payload.isEmpty {
                controller.preSelectedReportId = payload[Constants.RequestParameters.Expense.reportId] as? String
            }
        }
        return controller
    }
    
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
}
