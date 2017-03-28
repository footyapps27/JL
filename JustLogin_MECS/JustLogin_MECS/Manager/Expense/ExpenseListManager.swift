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
     * Method to get the list of selected expense id's.
     */
    func getExpenseIds(fromSelectedIndexPaths selectedIndices: [IndexPath]) -> [String] {
        var ids: [String] = []
        for index in selectedIndices {
            ids.append(expenses[index.row].id)
        }
        return ids
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
        return Utilities.getCategoryName(forExpense: expense)
    }
    
    /**
     * Method to get the formatted date & description for an expense.
     */
    func getDateAndDescription(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        var dateAndDescription = Constants.General.emptyString
        
        if let date = expense.date {
            dateAndDescription = Utilities.convertDateToStringForDisplay(date)
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
        return Utilities.getFormattedAmount(forExpense: expense)
    }
    
    /**
     * Method to get the formatted status
     */
    func getExpenseStatus(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        return Utilities.getStatus(forExpense: expense).capitalized
    }
    
    /**
     * Method to get the attachment image
     */
    func getAttachmentImage(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        return expense.hasAttachment ? Constants.UIImageNames.attachmentActive : Constants.UIImageNames.attachmentDefault
    }
    
    /**
     * Method to get the policy violation image
     */
    func getPolicyViolationImage(forIndexPath indexPath: IndexPath) -> String {
        let expense = expenses[indexPath.row]
        return expense.hasPolicyViolation ? Constants.UIImageNames.policyViolationActive : Constants.UIImageNames.policyViolationDefault
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
    func deleteExpenses(ids: [String],completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        expenseService.delete(expenseIds: ids) { [weak self] (result) in
            switch(result) {
            case .success(_):
                self?.updateExpenseList(deletedIds: ids)
                completionHandler(ManagerResponseToController.success())
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        }
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension ExpenseListManager {
    
    fileprivate func updateExpenseList(deletedIds: [String]) {
        expenses = expenses.filter { !deletedIds.contains($0.id) }
    }
}
