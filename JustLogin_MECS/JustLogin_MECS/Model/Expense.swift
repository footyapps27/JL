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
    
    var amount: Double = Constants.Defaults.amount
    
    var status: Int = Constants.Defaults.ExpenseStatus
    
    var exchange: Double = Constants.Defaults.exchangeRate
    
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
        
        id = json[Constants.ResponseParameters.expenseId].stringValue
        
        if let jsonDate = json[Constants.ResponseParameters.date].string {
            date = Utilities.convertServerStringToDate(jsonDate)
        }
        
        amount = json[Constants.ResponseParameters.amount].doubleValue

        exchange = json[Constants.ResponseParameters.exchange].doubleValue

        status = json[Constants.ResponseParameters.status].intValue
        
        description = json[Constants.ResponseParameters.description].stringValue
        
        location = json[Constants.ResponseParameters.location].stringValue
        
        referenceNumber = json[Constants.ResponseParameters.referenceNumber].stringValue
        
        notes = json[Constants.ResponseParameters.notes].stringValue
        
        merchantName = json[Constants.ResponseParameters.merchantName].stringValue
        
        paymentMode = json[Constants.ResponseParameters.paymentMode].stringValue
        
        categoryId = json[Constants.ResponseParameters.categoryId].stringValue
        
        currencyId = json[Constants.ResponseParameters.currencyId].stringValue
        
        reportId = json[Constants.ResponseParameters.reportId].stringValue
    }
}
