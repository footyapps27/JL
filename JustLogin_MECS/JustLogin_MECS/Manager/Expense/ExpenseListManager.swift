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
struct ExpenseListManager {

    var expenseService: IExpenseService = ExpenseService()

    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    func getAllExpenses(complimentionHandler: (@escaping (Result<[Expense]>) -> Void)) {
        expenseService.getAllExpenses({ (expenses) in
            log.debug(expenses)
        })
    }
    
    func createNewExpense(_ expense: Expense, complimentionHandler: (@escaping (Result<Expense>) -> Void)) {
        expenseService.create(expense: expense) { (expense) in
            log.debug(expense)
        }
    }
}
