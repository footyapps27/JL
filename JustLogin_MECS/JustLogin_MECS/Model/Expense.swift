//
//  Expense.swift
//  JustLogin_MECS
//
//  Created by Samrat on 19/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Expense {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var id: String?
    
    var date: Date?
    
    var amount: Double = Constants.Defaults.Amount
    
    var status: Int = Constants.Defaults.ExpenseStatus
    
    var exchange: Double = Constants.Defaults.ExchangeRate
    
    var description: String?
    
    var location: String?
    
    var referenceNumber: String?
    
    var notes: String?
    
    var merchantName: String?
    
    var paymentMode: String?
    
    var categoryId: String?
    
    var currencyId: String?
    
    var reportId: String?
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    
    /**
     * Default initializer
     */
    init() { }
    
    /**
     * Initialize using the JSON object received from the server.
     */
    init(withJSON json:JSON) {
        
        if json[Constants.ResponseParameters.ExpenseId].exists() {
            id = json[Constants.ResponseParameters.ExpenseId].stringValue
        }
        
        if let jsonDate = json[Constants.ResponseParameters.Date].string {
            date = Utilities.convertServerStringToDate(jsonDate)
        }
        
        if json[Constants.ResponseParameters.Amount].exists() {
            amount = json[Constants.ResponseParameters.Amount].doubleValue
        }
        
        if json[Constants.ResponseParameters.Exchange].exists() {
            exchange = json[Constants.ResponseParameters.Exchange].doubleValue
        }
        
        if json[Constants.ResponseParameters.Status].exists() {
            status = json[Constants.ResponseParameters.Status].intValue
        }
        
        if json[Constants.ResponseParameters.Description].exists() {
            description = json[Constants.ResponseParameters.Description].stringValue
        }
        
        if json[Constants.ResponseParameters.Location].exists() {
            location = json[Constants.ResponseParameters.Location].stringValue
        }
        
        if json[Constants.ResponseParameters.ReferenceNumber].exists() {
            referenceNumber = json[Constants.ResponseParameters.ReferenceNumber].stringValue
        }
        
        if json[Constants.ResponseParameters.Notes].exists() {
            notes = json[Constants.ResponseParameters.Notes].stringValue
        }
        
        //if json[Constants.ResponseParameters.MerchantName].exists() {
            merchantName = json["Ts"].stringValue
        //}
        
        if json[Constants.ResponseParameters.PaymentMode].exists() {
            paymentMode = json[Constants.ResponseParameters.PaymentMode].stringValue
        }
        
        if json[Constants.ResponseParameters.CategoryId].exists() {
            categoryId = json[Constants.ResponseParameters.CategoryId].stringValue
        }
        
        if json[Constants.ResponseParameters.CurrencyId].exists() {
            currencyId = json[Constants.ResponseParameters.CurrencyId].stringValue
        }
        
        if json[Constants.ResponseParameters.ReportId].exists() {
            reportId = json[Constants.ResponseParameters.ReportId].stringValue
        }
    }
}
