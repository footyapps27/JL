//
//  ReviewSelectExpenseManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
/**
 * Manager for ReviewSelectExpenseViewController
 */
class ReviewSelectExpenseManager {
    
    var expenseService: IExpenseService = ExpenseService()
    
    var expenses: [Expense] = []
    
    var selectedIndices = Set<Int>()
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ReviewSelectExpenseManager {
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
     * Method to get the list of selected expenses.
     */
    func getSelectedExpenses() -> [Expense] {
        var selectedExpenses: [Expense] = []
        for index in selectedIndices {
            selectedExpenses.append(expenses[index])
        }
        return selectedExpenses
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ReviewSelectExpenseManager {
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
extension ReviewSelectExpenseManager {
    /**
     * Method to fetch all expense from the server.
     */
    func fetchExpenses(completionHandler: (@escaping (ManagerResponseToController<[Expense]>) -> Void)) {
        expenseService.getAllExpenses({ [weak self] (result) in
            switch(result) {
            case .success(let expenseList):
                // Only reports whose status is not submitted will be considered.
                self?.expenses = self?.filterUnreportedExpenses(expenseList) ?? []
                completionHandler(ManagerResponseToController.success(self?.expenses ?? []))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReviewSelectExpenseManager {
    func filterUnreportedExpenses(_ expenses: [Expense]) -> [Expense] {
        return expenses.filter({ (expense) -> Bool in
            if expense.status == ExpenseStatus.unreported.rawValue {
                return true
            }
            return false
        })
    }
}
