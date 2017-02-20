//
//  Report.swift
//  JustLogin_MECS
//
//  Created by Samrat on 19/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Report {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let id: String
    
    let amount: Double
    
    let businessPurpose: String
    
    let startDate: String
    
    let endDate: String
    
    let title: String
    
    let status: Int
    
    var expenseIds: [String] = []
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    init(_ json:JSON) {
        id = json[Constants.ResponseParameters.ReportId].exists() ? json[Constants.ResponseParameters.ReportId].stringValue : Constants.General.EmptyString
        
        amount = json[Constants.ResponseParameters.Amount].exists() ? json[Constants.ResponseParameters.Amount].doubleValue : Constants.Defaults.Amount
        
        businessPurpose = json[Constants.ResponseParameters.BusinessPurpose].exists() ? json[Constants.ResponseParameters.BusinessPurpose].stringValue : Constants.General.EmptyString
        
        // TODO: - Convert to date
        startDate = json[Constants.ResponseParameters.StartDate].exists() ? json[Constants.ResponseParameters.StartDate].stringValue : Constants.General.EmptyString
        
        // TODO: - Convert to date
        endDate = json[Constants.ResponseParameters.EndDate].exists() ? json[Constants.ResponseParameters.EndDate].stringValue : Constants.General.EmptyString
        
        title = json[Constants.ResponseParameters.Title].exists() ? json[Constants.ResponseParameters.Title].stringValue : Constants.General.EmptyString
        
        status = json[Constants.ResponseParameters.Status].exists() ? json[Constants.ResponseParameters.Status].intValue : Constants.Defaults.ReportStatus
        
        let jsonExpenseIds = json[Constants.ResponseParameters.ExpenseIds].exists() ? json[Constants.ResponseParameters.ExpenseIds].arrayValue : []
        for expenseId in jsonExpenseIds {
            expenseIds.append(expenseId.stringValue)
        }
    }
}
