//
//  ReportMemberDetail.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReportMemberDetail {
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var id: String = Constants.General.emptyString
    
    var name: String = Constants.General.emptyString
    
    var date: Date?
    
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
        id = json[Constants.ResponseParameters.memberId].stringValue
        name = json[Constants.ResponseParameters.fullName].stringValue
        if let jsonDate = json[Constants.ResponseParameters.date].string {
            date = Utilities.convertServerStringToDate(jsonDate)
        }
    }
}
