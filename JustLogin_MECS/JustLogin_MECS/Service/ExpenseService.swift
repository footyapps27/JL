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
     * Method to retrieve details of an expense.
     */
    func getExpenseDetails(expenseId: String, completionHandler:( @escaping (Result<Expense>) -> Void))
    
    /**
     * Create a new expense.
     */
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Expense>) -> Void))
    
    /**
     * Update an existing expense.
     */
    func update(payload: [String : Any], completionHandler:( @escaping (Result<Expense>) -> Void))
    
    /**
     * Delete an existing expense.
     */
    func delete(expenseIds: [String], completionHandler:( @escaping (Result<Void>) -> Void))
}

/***********************************/
// MARK: - IExpenseService implementation
/***********************************/
struct ExpenseService : IExpenseService {
    
    var serviceAdapter: NetworkAdapter = NetworkConfiguration.getNetworkAdapter()
    
    func getAllExpenses(_ completionHandler:( @escaping (Result<[Expense]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Expense.getAllExpenses, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                var allExpenses: [Expense] = []
                if let jsonExpenses = success[Constants.ResponseParameters.expenses] as? [Any] {
                    for expense in jsonExpenses {
                        allExpenses.append(Expense(withJSON: JSON(expense)))
                    }
                }
                completionHandler(Result.success(allExpenses))
                
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
                
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func getExpenseDetails(expenseId: String, completionHandler:( @escaping (Result<Expense>) -> Void)) {
        let payload = getPayloadForExpenseDetails(expenseId)
        serviceAdapter.post(destination: Constants.URLs.Expense.expenseDetails
        , payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                let expense = Expense(withJSON: JSON(success))
                completionHandler(Result.success(expense))
                
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
                
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Expense>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Expense.createExpense
        , payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                let expense = Expense(withJSON: JSON(success))
                completionHandler(Result.success(expense))
                
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
                
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func update(payload: [String : Any], completionHandler:( @escaping (Result<Expense>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Expense.updateExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                let expense = Expense(withJSON: JSON(success))
                completionHandler(Result.success(expense))
                
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
                
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func delete(expenseIds: [String], completionHandler:( @escaping (Result<Void>) -> Void)) {
        let payload = getPayloadForDeleteExpense(expenseIds)
        serviceAdapter.post(destination: Constants.URLs.Expense.deleteExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(_ , _):
                completionHandler(Result.success())
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
}

/***********************************/
// MARK: - Payload for services
/***********************************/
extension ExpenseService {
    /**
     * Method to format payload for expense details.
     */
    func getPayloadForExpenseDetails(_ expenseId: String) -> [String : Any] {
        return [Constants.RequestParameters.General.ids : [expenseId]]
    }
    
    /**
     * Method to format payload for delete expense.
     */
    func getPayloadForDeleteExpense(_ expenseIds: [String]) -> [String : Any] {
        return [Constants.RequestParameters.General.ids : expenseIds]
    }
}
