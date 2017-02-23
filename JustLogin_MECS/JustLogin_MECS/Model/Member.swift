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
    var id: String?
    
    var userId: String?
    
    var fullName: String?
    
    var status: Bool = false
    
    var organizationId: String?
    
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
        
        if json[Constants.ResponseParameters.MemberId].exists() {
            id = json[Constants.ResponseParameters.MemberId].stringValue
        }
        
        if json[Constants.ResponseParameters.UserId].exists() {
            userId = json[Constants.ResponseParameters.UserId].stringValue
        }
        
        if json[Constants.ResponseParameters.FullName].exists() {
            fullName = json[Constants.ResponseParameters.FullName].stringValue
        }
        
        if json[Constants.ResponseParameters.Status].exists() {
            status =  json[Constants.ResponseParameters.Status].boolValue
        }
        
        if json[Constants.ResponseParameters.OrganizationId].exists() {
            organizationId =  json[Constants.ResponseParameters.OrganizationId].stringValue
        }
        
        role = Role(withJSON: json[Constants.ResponseParameters.Role])
    }
}
