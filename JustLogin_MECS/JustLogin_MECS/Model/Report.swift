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
        id = json[Constants.ResponseParameters.ReportId].exists() ? json[Constants.ResponseParameters.ReportId].stringValue : Constants.General.EmptyString
        
        amount = json[Constants.ResponseParameters.Amount].exists() ? json[Constants.ResponseParameters.Amount].doubleValue : Constants.Defaults.Amount
        
        businessPurpose = json[Constants.ResponseParameters.BusinessPurpose].exists() ? json[Constants.ResponseParameters.BusinessPurpose].stringValue : Constants.General.EmptyString
        
        if let jsonStartDate = json[Constants.ResponseParameters.StartDate].string {
            startDate = Utilities.convertServerStringToDate(jsonStartDate)
        }
        
        if let jsonEndDate = json[Constants.ResponseParameters.EndDate].string {
            endDate = Utilities.convertServerStringToDate(jsonEndDate)
        }
        
        title = json[Constants.ResponseParameters.Title].exists() ? json[Constants.ResponseParameters.Title].stringValue : Constants.General.EmptyString
        
        status = json[Constants.ResponseParameters.Status].exists() ? json[Constants.ResponseParameters.Status].intValue : Constants.Defaults.ReportStatus
        
        let jsonExpenseIds = json[Constants.ResponseParameters.ExpenseIds].exists() ? json[Constants.ResponseParameters.ExpenseIds].arrayValue : []
        for expenseId in jsonExpenseIds {
            expenseIds.append(expenseId.stringValue)
        }
    }
}
