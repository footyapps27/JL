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
    
    var description: String?
    
    var location: String?
    
    var referenceNumber: String?
    
    var notes: String?
    
    var merchantName: String?
    
    var paymentMode: String?
    
    var categoryId: String?
    
    var currencyId: String?
    
    var organizationId: String?
    
    // TODO: - Speak to Bavithra about the JSON
    var submitterId: String?
    
    var reportId: String?
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    
    /**
     * Default initializer
     */
    init() {
        
    }
    
    /**
     * Initialize using the JSON object received from the server.
     */
    init(withJSON json:JSON) {
        id = json[Constants.ResponseParameters.ExpenseId].exists() ? json[Constants.ResponseParameters.ExpenseId].stringValue : Constants.General.EmptyString
        
        if let jsonDate = json[Constants.ResponseParameters.Date].string {
            date = Utilities.convertServerStringToDate(jsonDate)
        }
        
        amount = json[Constants.ResponseParameters.Amount].exists() ? json[Constants.ResponseParameters.Amount].doubleValue : Constants.Defaults.Amount
        
        status = json[Constants.ResponseParameters.Status].exists() ? json[Constants.ResponseParameters.Status].intValue : Constants.Defaults.ExpenseStatus
        
        description = json[Constants.ResponseParameters.Description].exists() ? json[Constants.ResponseParameters.Description].stringValue : Constants.General.EmptyString
        
        location = json[Constants.ResponseParameters.Location].exists() ? json[Constants.ResponseParameters.Location].stringValue : Constants.General.EmptyString
        
        referenceNumber = json[Constants.ResponseParameters.ReferenceNumber].exists() ? json[Constants.ResponseParameters.ReferenceNumber].stringValue : Constants.General.EmptyString
        
        notes = json[Constants.ResponseParameters.Notes].exists() ? json[Constants.ResponseParameters.Notes].stringValue : Constants.General.EmptyString
        
        merchantName = json[Constants.ResponseParameters.MerchantName].exists() ? json[Constants.ResponseParameters.MerchantName].stringValue : Constants.General.EmptyString
        
        paymentMode = json[Constants.ResponseParameters.PaymentMode].exists() ? json[Constants.ResponseParameters.PaymentMode].stringValue : Constants.General.EmptyString
        
        categoryId = json[Constants.ResponseParameters.CategoryId].exists() ? json[Constants.ResponseParameters.CategoryId].stringValue : Constants.General.EmptyString
        
        currencyId = json[Constants.ResponseParameters.CurrencyId].exists() ? json[Constants.ResponseParameters.CurrencyId].stringValue : Constants.General.EmptyString
        
        organizationId = json[Constants.ResponseParameters.OrganizationId].exists() ? json[Constants.ResponseParameters.OrganizationId].stringValue : Constants.General.EmptyString
        
        submitterId = json[Constants.ResponseParameters.SubmitterId].exists() ? json[Constants.ResponseParameters.SubmitterId].stringValue : Constants.General.EmptyString
        
        reportId = json[Constants.ResponseParameters.ReportId].exists() ? json[Constants.ResponseParameters.ReportId].stringValue : Constants.General.EmptyString
    }
}
