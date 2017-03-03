//
//  ExpenseDetailsManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class ExpenseDetailsManager {
    
    var expense: Expense?
    
    var expenseService: IExpenseService = ExpenseService()
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ExpenseDetailsManager {
    /**
     * Method to fetch all expenses from the server.
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
