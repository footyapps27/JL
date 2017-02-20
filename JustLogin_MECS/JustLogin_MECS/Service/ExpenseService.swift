//
//  ExpenseService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IExpenseService {
    
    /**
     * Method to retrieve all expenses.
     */
    func getAllExpenses(_ completionHandler:( @escaping (Result<[Expense]>) -> Void))
    
    /**
     * Create a new expense.
     */
    func create(expense: Expense, completionHandler:( @escaping (Result<Expense>) -> Void))
    
    /**
     * Update an existing expense.
     */
    func update(expense: Expense, completionHandler:( @escaping (Result<Expense>) -> Void))
    
    /**
     * Delete an existing expense.
     */
    func delete(expenseId: String, completionHandler:( @escaping (Result<Expense>) -> Void))
}

struct ExpenseService : IExpenseService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - IExpenseService implementation
    /***********************************/
    func getAllExpenses(_ completionHandler:( @escaping (Result<[Expense]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.GetAllExpenses, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .Success(let success, _ ):
                var allExpenses: [Expense] = []
                if let jsonExpenses = success[Constants.ResponseParameters.Expenses] as? [Any] {
                    for expense in jsonExpenses {
                        allExpenses.append(Expense(JSON(expense)))
                    }
                }
                completionHandler(Result.Success(allExpenses))
                
            case .Errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.Error(error))
                
            case .Failure(let description):
                completionHandler(Result.Failure(description))
            }
        }
    }
    
    func create(expense: Expense, completionHandler:( @escaping (Result<Expense>) -> Void)) {
        let payload = getPayloadForCreateExpense(expense)
        serviceAdapter.post(destination: Constants.URLs.CreateExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
        }
    }
    
    func update(expense: Expense, completionHandler:( @escaping (Result<Expense>) -> Void)) {
        let payload = getPayloadForUpdateExpense(expense)
        serviceAdapter.post(destination: Constants.URLs.CreateExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
        }
    }
    
    func delete(expenseId: String, completionHandler:( @escaping (Result<Expense>) -> Void)) {
        let payload = getPayloadForDeleteExpense(expenseId)
        serviceAdapter.post(destination: Constants.URLs.CreateExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
        }
    }
}

extension ExpenseService {
    
    /**
     * Method to format payload for create expense.
     */
    func getPayloadForCreateExpense(_ expense: Expense) -> [String : String] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
    
    /**
     * Method to format payload for update expense.
     */
    func getPayloadForUpdateExpense(_ expense: Expense) -> [String : String] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
    
    /**
     * Method to format payload for delete expense.
     */
    func getPayloadForDeleteExpense(_ expenseId: String) -> [String : String] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
}
