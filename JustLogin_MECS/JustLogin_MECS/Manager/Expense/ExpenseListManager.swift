//
//  ExpenseListManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for ExpenseListViewController
 */
class ExpenseListManager {
    
    var expenseService: IExpenseService = ExpenseService()
    
    var expenses: [Expense] = []
    
    var selectedIndices = Set<Int>()
    
}

/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ExpenseListManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getExpenses() -> [Expense] {
        return expenses
    }
    
    /**
     * When in multiple selection mode, add the selection of the user.
     */
    func addExpenseToSelectedExpenses(forIndexPath indexPath: IndexPath) {
        selectedIndices.insert(indexPath.row)
    }
    
    /**
     * Method to get the list of selected expense id's.
     */
    func getSelectedExpenseIds() -> [String] {
        var ids: [String] = []
        for index in selectedIndices {
            ids.append(expenses[index].id)
        }
        return ids
    }
    
    
    
    /**
     * Remove all the indices that was earlier tracked.
     */
    func refreshSelectedIndices() {
        selectedIndices.removeAll()
    }
}

/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ExpenseListManager {
    /**
     * Method to get the category name for Id
     */
    func getCategoryName(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        if let category = Singleton.sharedInstance.organization?.categories[expense.categoryId] {
            return category.name
        }
        log.error("Category not found")
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the formatted date & description for an expense.
     */
    func getDateAndDescription(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        var dateAndDescription = Constants.General.emptyString
        
        if let date = expense.date {
            dateAndDescription = Utilities.convertDateToString(date)
        } else {
            log.error("Expense date is nil")
        }
        
        if !expense.merchantName.isEmpty {
            dateAndDescription += " | " + expense.merchantName
        }
        
        return dateAndDescription
    }
    
    /**
     * Method to get the formatted amount (currency + amount)
     */
    func getFormattedAmount(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        var currencyAndAmount = Constants.General.emptyString
        
        if let category = Singleton.sharedInstance.organization?.currencies[expense.currencyId] {
            currencyAndAmount = category.symbol
        }
        
        currencyAndAmount += " " + String(format: Constants.General.decimalFormat, expense.amount)
        
        return currencyAndAmount
    }
    
    /**
     * Method to get the formatted status
     */
    func getExpenseStatus(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        if let status = ExpenseStatus(rawValue: expense.status) {
            return status.name.capitalized
        }
        log.error("Status of expense is invalid")
        return Constants.General.emptyString
    }
}

/***********************************/
// MARK: - Service Calls
/***********************************/
extension ExpenseListManager {
    
    /**
     * Method to fetch all expenses from the server.
     */
    func fetchExpenses(completionHandler: (@escaping (ManagerResponseToController<[Expense]>) -> Void)) {
        expenseService.getAllExpenses({ [weak self] (result) in
            switch(result) {
            case .success(let expenseList):
                self?.expenses = expenseList
                completionHandler(ManagerResponseToController.success(expenseList))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
    
    /**
     * Delete a list of expenses. 
     * This will alse update expenses
     */
    func deleteSelectedExpenses(completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        expenseService.delete(expenseIds: getSelectedExpenseIds()) { [weak self] (result) in
            switch(result) {
            case .success(_):
                self?.updateExpensesAfterDelete()
                completionHandler(ManagerResponseToController.success())
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        }
    }
    
    /**
     * Create a new expense.
     */
    func createNewExpense(_ expense: Expense, complimentionHandler: (@escaping (Result<Expense>) -> Void)) {
        expenseService.create(expense: expense) { (expense) in
            log.debug(expense)
        }
    }
}

/***********************************/
// MARK: - Private Methods
/***********************************/
extension ExpenseListManager {
    /**
     * Update the list of expenses after the deletion is successful.
     */
    fileprivate func updateExpensesAfterDelete() {
        expenses = expenses
            .enumerated()
            .filter { !selectedIndices.contains($0.offset) }
            .map { $0.element }
        refreshSelectedIndices()
    }
}
