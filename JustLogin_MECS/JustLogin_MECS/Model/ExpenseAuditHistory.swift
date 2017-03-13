//
//  ExpenseAuditHistory.swift
//  JustLogin_MECS
//
//  Created by Samrat on 9/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AuditHistory {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var description: String = Constants.General.emptyString
    
    var reason: String = Constants.General.emptyString
    
    var date: Date?
    
    var createdBy: String = Constants.General.emptyString
    
    /**
     * Initialize using the JSON object received from the server.
     */
    init(withJSON json:JSON) {
        
        description = json[Constants.ResponseParameters.description].stringValue
        
        reason = json[Constants.ResponseParameters.reason].stringValue
        
        createdBy = json[Constants.ResponseParameters.createdBy].stringValue
        
        if let jsonDate = json[Constants.ResponseParameters.createdDate].string {
            date = Utilities.convertAuditHistoryServerStringToDate(jsonDate)
        }
    }
}
