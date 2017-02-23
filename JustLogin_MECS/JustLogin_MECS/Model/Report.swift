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
    
    var amount: Double = Constants.Defaults.amount
    
    var businessPurpose: String?
    
    var startDate: Date?
    
    var endDate: Date?
    
    var title: String?
    
    var status: Int = Constants.Defaults.reportStatus
    
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
        
        
            id = json[Constants.ResponseParameters.reportId].stringValue
        
        
            amount = json[Constants.ResponseParameters.amount].doubleValue
        
        
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
    }
}
