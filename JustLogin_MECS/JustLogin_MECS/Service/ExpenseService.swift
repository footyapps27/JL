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
    func delete(expenseIds: [String], completionHandler:( @escaping (Result<Void>) -> Void))
}

struct ExpenseService : IExpenseService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - IExpenseService implementation
    /***********************************/
    func getAllExpenses(_ completionHandler:( @escaping (Result<[Expense]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.getAllExpenses, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
    
    func create(expense: Expense, completionHandler:( @escaping (Result<Expense>) -> Void)) {
        let payload = getPayloadForCreateExpense(expense)
        serviceAdapter.post(destination: Constants.URLs.updateExpense
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
    
    func update(expense: Expense, completionHandler:( @escaping (Result<Expense>) -> Void)) {
        let payload = getPayloadForUpdateExpense(expense)
        serviceAdapter.post(destination: Constants.URLs.createExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
        serviceAdapter.post(destination: Constants.URLs.deleteExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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

extension ExpenseService {
    
    /**
     * Method to format payload for create expense.
     */
    func getPayloadForCreateExpense(_ expense: Expense) -> [String : Any] {
        var payload: [String : Any] = [:]
        
        payload[Constants.RequestParameters.Expense.amount] = expense.amount
        
        payload[Constants.RequestParameters.Expense.status] = expense.status
        
        payload[Constants.RequestParameters.Expense.exchange] = expense.exchange
        
        if let date = expense.date {
            payload[Constants.RequestParameters.Expense.date] = Utilities.convertDateToString(date)
        }
        
        if !expense.description.isEmpty {
            payload[Constants.RequestParameters.Expense.description] = expense.description
        }
        
        if !expense.location.isEmpty {
            payload[Constants.RequestParameters.Expense.location] = expense.location
        }
        
        if !expense.referenceNumber.isEmpty {
            payload[Constants.RequestParameters.Expense.referenceNumber] = expense.referenceNumber
        }
        
        if !expense.notes.isEmpty {
            payload[Constants.RequestParameters.Expense.notes] = expense.notes
        }
        
        if !expense.paymentMode.isEmpty {
            payload[Constants.RequestParameters.Expense.paymentMode] = expense.paymentMode
        }
        
        if !expense.categoryId.isEmpty {
            payload[Constants.RequestParameters.Expense.categoryId] = expense.categoryId
        }
        
        if !expense.currencyId.isEmpty {
            payload[Constants.RequestParameters.Expense.currencyId] = expense.currencyId
        }
        
        if !expense.reportId.isEmpty {
            payload[Constants.RequestParameters.Expense.reportId] = expense.reportId
        }
        
        return payload
    }
    
    /**
     * Method to format payload for update expense.
     */
    func getPayloadForUpdateExpense(_ expense: Expense) -> [String : Any] {
        var payload: [String : Any] = getPayloadForCreateExpense(expense)
        
        if !expense.id.isEmpty {
            payload[Constants.RequestParameters.Expense.expenseId] = expense.id
        }
        return payload
    }
    
    /**
     * Method to format payload for delete expense.
     */
    func getPayloadForDeleteExpense(_ expenseIds: [String]) -> [String : Any] {
        return [Constants.RequestParameters.General.ids : expenseIds]
    }
}
