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
    var id: String = Constants.General.emptyString
    
    var amount: Double = Constants.Defaults.amount
    
    var reportNumber: String = Constants.General.emptyString
    
    var businessPurpose: String = Constants.General.emptyString
    
    var startDate: Date?
    
    var endDate: Date?
    
    var title: String = Constants.General.emptyString
    
    var status: Int = Constants.Defaults.reportStatus
    
    var rejectionReason: String = Constants.General.emptyString
    
    var submittedToId: String = Constants.General.emptyString
    
    var submittedToName: String = Constants.General.emptyString
    
    var expenseIds: [String] = []
    
    var expenses: [Expense] = []
    
    var customFields: [[String : Any]] = []
    
    var auditHistory: [AuditHistory] = []
    
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
        
        id = json[Constants.ResponseParameters.reportId].stringValue
        
        amount = json[Constants.ResponseParameters.amount].doubleValue
        
        reportNumber = json[Constants.ResponseParameters.reportNumber].stringValue
        
        businessPurpose = json[Constants.ResponseParameters.businessPurpose].stringValue
        
        title = json[Constants.ResponseParameters.title].stringValue
        
        status = json[Constants.ResponseParameters.status].intValue
        
        if let jsonStartDate = json[Constants.ResponseParameters.startDate].string {
            startDate = Utilities.convertServerStringToDate(jsonStartDate)
        }
        
        if let jsonEndDate = json[Constants.ResponseParameters.endDate].string {
            endDate = Utilities.convertServerStringToDate(jsonEndDate)
        }
        
        let jsonExpenseIds = json[Constants.ResponseParameters.expenseIds].exists() ? json[Constants.ResponseParameters.expenseIds].arrayValue : []
        for expenseId in jsonExpenseIds {
            expenseIds.append(expenseId.stringValue)
        }
        
        let jsonExpenses = json[Constants.ResponseParameters.expenses].exists() ? json[Constants.ResponseParameters.expenses].arrayValue : []
        for jsonExpense in jsonExpenses {
            let expense = Expense(withJSON: jsonExpense)
            expenses.append(expense)
        }
        
        let jsonHistories = json[Constants.ResponseParameters.history].exists() ? json[Constants.ResponseParameters.history].arrayValue : []
        for jsonHistory in jsonHistories {
            let history = AuditHistory(withJSON: jsonHistory)
            auditHistory.append(history)
        }
    }
}
