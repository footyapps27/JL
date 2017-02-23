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
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getExpenses() -> [Expense] {
        return expenses
    }
    
    /**
     * Method to get the category name for Id
     */
    func getCategoryName(forExpense expense: Expense) -> String? {
        if let categoryId = expense.categoryId {
            return Singleton.sharedInstance.organization?.categories[categoryId]?.name
        }
        log.error("Category Id is nil")
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the formatted date & description for an expense.
     */
    func getDateAndDescription(forExpense expense: Expense) -> String? {
        var dateAndDescription = Constants.General.emptyString
        
        if let date = expense.date {
            dateAndDescription = Utilities.convertDateToString(date)
        } else {
            log.error("Expense date is nil")
        }
        
        if !(expense.merchantName ?? Constants.General.emptyString).isEmpty {
            dateAndDescription += " | " + expense.merchantName!
        }
        
        return dateAndDescription
    }
    
    func fetchExpenses(complimentionHandler: (@escaping (ManagerResponseToController<[Expense]>) -> Void)) {
        expenseService.getAllExpenses({ [weak self] (result) in
            switch(result) {
            case .success(let expenseList):
                self?.expenses = expenseList
                complimentionHandler(ManagerResponseToController.success(expenseList))
            case .error(let serviceError):
                complimentionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                complimentionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
    
    func createNewExpense(_ expense: Expense, complimentionHandler: (@escaping (Result<Expense>) -> Void)) {
        expenseService.create(expense: expense) { (expense) in
            log.debug(expense)
        }
    }
}
