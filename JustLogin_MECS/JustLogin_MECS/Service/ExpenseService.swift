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
            case .success(let success, _ ):
                var allExpenses: [Expense] = []
                if let jsonExpenses = success[Constants.ResponseParameters.Expenses] as? [Any] {
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
        serviceAdapter.post(destination: Constants.URLs.UpdateExpense
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
        serviceAdapter.post(destination: Constants.URLs.CreateExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
        serviceAdapter.post(destination: Constants.URLs.DeleteExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
        
        payload[Constants.RequestParameters.Expense.Amount] = expense.amount
        
        payload[Constants.RequestParameters.Expense.Status] = expense.status
        
        payload[Constants.RequestParameters.Expense.Exchange] = expense.exchange
        
        if let date = expense.date {
            payload[Constants.RequestParameters.Expense.Date] = Utilities.convertDateToString(date)
        }
        
        if let description = expense.description {
            payload[Constants.RequestParameters.Expense.Description] = description
        }
        
        if let location = expense.location {
            payload[Constants.RequestParameters.Expense.Location] = location
        }
        
        if let referenceNumber = expense.referenceNumber {
            payload[Constants.RequestParameters.Expense.ReferenceNumber] = referenceNumber
        }
        
        if let notes = expense.notes {
            payload[Constants.RequestParameters.Expense.Notes] = notes
        }
        
        if let paymentMode = expense.paymentMode {
            payload[Constants.RequestParameters.Expense.PaymentMode] = paymentMode
        }
        
        if let categoryId = expense.categoryId {
            payload[Constants.RequestParameters.Expense.CategoryId] = categoryId
        }
        
        if let currencyId = expense.currencyId {
            payload[Constants.RequestParameters.Expense.CurrencyId] = currencyId
        }
        
        if let reportId = expense.reportId {
            payload[Constants.RequestParameters.Expense.ReportId] = reportId
        }
        
        return payload
    }
    
    /**
     * Method to format payload for update expense.
     */
    func getPayloadForUpdateExpense(_ expense: Expense) -> [String : Any] {
        var payload: [String : Any] = getPayloadForCreateExpense(expense)
        
        if let expenseId = expense.id {
            payload[Constants.RequestParameters.Expense.ExpenseId] = expenseId
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
