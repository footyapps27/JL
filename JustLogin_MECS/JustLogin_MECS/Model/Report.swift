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
    var id: String?
    
    var amount: Double = Constants.Defaults.Amount
    
    var businessPurpose: String?
    
    var startDate: Date?
    
    var endDate: Date?
    
    var title: String?
    
    var status: Int = Constants.Defaults.ReportStatus
    
    var expenseIds: [String] = []
    
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
        
        if json[Constants.ResponseParameters.ReportId].exists() {
            id = json[Constants.ResponseParameters.ReportId].stringValue
        }
        
        if json[Constants.ResponseParameters.Amount].exists() {
            amount = json[Constants.ResponseParameters.Amount].doubleValue
        }
        
        if json[Constants.ResponseParameters.BusinessPurpose].exists() {
            businessPurpose = json[Constants.ResponseParameters.BusinessPurpose].stringValue
        }
        
        if json[Constants.ResponseParameters.Title].exists() {
            title = json[Constants.ResponseParameters.Title].stringValue
        }
        
        if json[Constants.ResponseParameters.Status].exists() {
            status = json[Constants.ResponseParameters.Status].intValue
        }
        
        if let jsonStartDate = json[Constants.ResponseParameters.StartDate].string {
            startDate = Utilities.convertServerStringToDate(jsonStartDate)
        }
        
        if let jsonEndDate = json[Constants.ResponseParameters.EndDate].string {
            endDate = Utilities.convertServerStringToDate(jsonEndDate)
        }

        let jsonExpenseIds = json[Constants.ResponseParameters.ExpenseIds].exists() ? json[Constants.ResponseParameters.ExpenseIds].arrayValue : []
        for expenseId in jsonExpenseIds {
            expenseIds.append(expenseId.stringValue)
        }
    }
}
