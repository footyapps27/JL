//
//  ExpenseDetailsManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class ExpenseDetailsManager {
    
    var expense: Expense = Expense()
    
    var expenseService: IExpenseService = ExpenseService()
}
/***********************************/
// MARK: - UI check value
/***********************************/
extension ExpenseDetailsManager {
    
    func isExpenseEditable() -> Bool {
        if expense.status == ExpenseStatus.unreported.rawValue ||
            expense.status == ExpenseStatus.unsubmitted.rawValue {
            return true
        }
        return false
    }
}
/***********************************/
// MARK: - TableView Header UI update
/***********************************/
extension ExpenseDetailsManager {
    /**
     * Method to get the category name for the expense
     */
    func getCategoryName() -> String {
        return Utilities.getCategoryName(forExpense: expense)
    }
    
    func getFormattedAmount() -> String {
        return Utilities.getFormattedAmount(forExpense: expense)
    }
    
    func getExpenseStatus() -> String {
        return Utilities.getStatus(forExpense: expense).uppercased()
    }
    
    func getExpenseDate() -> String {
        if let date = expense.date {
            return Utilities.convertDateToStringForDisplay(date)
        } else {
            log.error("Expense date is nil")
        }
        return Constants.General.emptyString
    }
    
    func getFieldsToDisplay() -> [String : String] {
        var fieldsToDisplay: [String : String] = [:]
        if expense.exchange > 0 {
            fieldsToDisplay[LocalizedString.exchangeRate] = String(expense.exchange)
        }
        
        if !expense.description.isEmpty {
            fieldsToDisplay[LocalizedString.description] = expense.description
        }
        
        if !expense.location.isEmpty {
            fieldsToDisplay[LocalizedString.description] = expense.location
        }
        
        if !expense.referenceNumber.isEmpty {
            fieldsToDisplay[LocalizedString.referenceNumber] = expense.referenceNumber
        }
        
        if !expense.notes.isEmpty {
            fieldsToDisplay[LocalizedString.notes] = expense.notes
        }
        
        if !expense.merchantName.isEmpty {
            fieldsToDisplay[LocalizedString.merchantName] = expense.merchantName
        }
        
        if !expense.paymentMode.isEmpty {
            fieldsToDisplay[LocalizedString.paymentMode] = expense.paymentMode
        }
        
        for dict in expense.customFields {
            // TODO: - Add the custom fields here
            print(dict)
        }
        
        return fieldsToDisplay
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ExpenseDetailsManager {
    /**
     * Method to fetch expense details from the server.
     */
    func fetchExpenseDetails(withExpenseId expenseId: String, completionHandler: (@escaping (ManagerResponseToController<Expense>) -> Void)) {
        expenseService.getExpenseDetails(expenseId: expenseId) { [weak self] (result) in
            switch(result) {
            case .success(let expense):
                self?.expense = expense
                completionHandler(ManagerResponseToController.success(expense))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        }
    }
}
