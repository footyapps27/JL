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
    
    func delete(expenseId: String, completionHandler:( @escaping (Result<Expense>) -> Void)) {
        let payload = getPayloadForDeleteExpense(expenseId)
        serviceAdapter.post(destination: Constants.URLs.deleteExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
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
        
        if let description = expense.description {
            payload[Constants.RequestParameters.Expense.description] = description
        }
        
        if let location = expense.location {
            payload[Constants.RequestParameters.Expense.location] = location
        }
        
        if let referenceNumber = expense.referenceNumber {
            payload[Constants.RequestParameters.Expense.referenceNumber] = referenceNumber
        }
        
        if let notes = expense.notes {
            payload[Constants.RequestParameters.Expense.notes] = notes
        }
        
        if let paymentMode = expense.paymentMode {
            payload[Constants.RequestParameters.Expense.paymentMode] = paymentMode
        }
        
        if let categoryId = expense.categoryId {
            payload[Constants.RequestParameters.Expense.categoryId] = categoryId
        }
        
        if let currencyId = expense.currencyId {
            payload[Constants.RequestParameters.Expense.currencyId] = currencyId
        }
        
        if let reportId = expense.reportId {
            payload[Constants.RequestParameters.Expense.reportId] = reportId
        }
        
        return payload
    }
    
    /**
     * Method to format payload for update expense.
     */
    func getPayloadForUpdateExpense(_ expense: Expense) -> [String : Any] {
        var payload: [String : Any] = getPayloadForCreateExpense(expense)
        
        if let expenseId = expense.id {
            payload[Constants.RequestParameters.Expense.expenseId] = expenseId
        }
        return payload
    }
    
    /**
     * Method to format payload for delete expense.
     */
    func getPayloadForDeleteExpense(_ expenseId: String) -> [String : Any] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
}
