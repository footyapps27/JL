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
    let id: String
    
    let date: String
    
    let amount: Double
    
    let status: Int
    
    let description: String
    
    let location: String
    
    let referenceNumber: String
    
    let notes: String
    
    let merchantName: String
    
    let paymentMode: String
    
    let categoryId: String
    
    let currencyId: String
    
    let organizationId: String
    
    let submitterId: String
    
    let reportId: String
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    init(_ json:JSON) {
        id = json[Constants.ResponseParameters.ExpenseId].exists() ? json[Constants.ResponseParameters.ExpenseId].stringValue : Constants.General.EmptyString
        
        // TODO: - Parse the data here & create a date object
        date = json[Constants.ResponseParameters.Date].exists() ? json[Constants.ResponseParameters.Date].stringValue : Constants.General.EmptyString
        
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
