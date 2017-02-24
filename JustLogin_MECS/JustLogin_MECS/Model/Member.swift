//
//  Member.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Member {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var id: String = Constants.General.emptyString
    
    var userId: String = Constants.General.emptyString
    
    var fullName: String = Constants.General.emptyString
    
    var status: Bool = false
    
    var organizationId: String = Constants.General.emptyString
    
    var role: Role?
    
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
        
        userId = json[Constants.ResponseParameters.userId].stringValue
        
        fullName = json[Constants.ResponseParameters.fullName].stringValue
        
        status =  json[Constants.ResponseParameters.status].boolValue
        
        organizationId =  json[Constants.ResponseParameters.organizationId].stringValue
        
        role = Role(withJSON: json[Constants.ResponseParameters.role])
    }
}
