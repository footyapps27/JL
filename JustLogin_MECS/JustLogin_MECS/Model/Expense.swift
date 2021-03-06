//
//  Expense.swift
//  JustLogin_MECS
//
//  Created by Samrat on 19/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

/***********************************/
// MARK: - Properties
/***********************************/
struct Expense {
    var id: String = Constants.General.emptyString
    
    var date: Date?
    
    var hasAttachment: Bool = false
    
    var hasPolicyViolation: Bool = false
    
    var amount: Double = Constants.Defaults.amount
    
    var status: Int = Constants.Defaults.ExpenseStatus
    
    var exchange: Double = Constants.Defaults.exchangeRate
    
    var description: String = Constants.General.emptyString
    
    var location: String = Constants.General.emptyString
    
    var referenceNumber: String = Constants.General.emptyString
    
    var notes: String = Constants.General.emptyString
    
    var merchantName: String = Constants.General.emptyString
    
    var paymentMode: String = Constants.General.emptyString
    
    var categoryId: String = Constants.General.emptyString
    
    var currencyId: String = Constants.General.emptyString
    
    var reportId: String = Constants.General.emptyString
    
    var reportTitle: String = Constants.General.emptyString
    
    var customFields: [[String : Any]] = []
    
    var auditHistory: [AuditHistory] = []
    
    /**
     * Default initializer
     */
    init() { }
}
/***********************************/
// MARK: - Initializer
/***********************************/
extension Expense {
    /**
     * Initialize using the JSON object received from the server.
     */
    init(withJSON json:JSON) {
        
        id = json[Constants.ResponseParameters.expenseId].stringValue
        
        if let jsonDate = json[Constants.ResponseParameters.date].string {
            date = Utilities.convertServerStringToDate(jsonDate)
        }
        
        hasAttachment = json[Constants.ResponseParameters.hasAttachment].boolValue
        
        hasPolicyViolation = json[Constants.ResponseParameters.hasPolicyViolation].boolValue
        
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
        
        // Report Details
        let jsonReport = json[Constants.ResponseParameters.report]
        reportId = jsonReport[Constants.ResponseParameters.reportId].stringValue
        reportTitle = jsonReport[Constants.ResponseParameters.title].stringValue
        
        // Audit History
        let jsonHistories = json[Constants.ResponseParameters.history].exists() ? json[Constants.ResponseParameters.history].arrayValue : []
        for jsonHistory in jsonHistories {
            let history = AuditHistory(withJSON: jsonHistory)
            auditHistory.append(history)
        }
    }
}
