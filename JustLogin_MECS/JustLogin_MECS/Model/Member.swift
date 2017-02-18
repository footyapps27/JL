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
    let id: String
    
    let userId: String
    
    let fullName: String
    
    let status: Bool
    
    let organizationId: String
    
    let role: Role
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    init(_ json:JSON) {
        id = json[Constants.ResponseParameters.MemberId].exists() ? json[Constants.ResponseParameters.MemberId].stringValue : Constants.General.EmptyString
        
        userId = json[Constants.ResponseParameters.UserId].exists() ? json[Constants.ResponseParameters.UserId].stringValue : Constants.General.EmptyString
        
        fullName = json[Constants.ResponseParameters.FullName].exists() ? json[Constants.ResponseParameters.FullName].stringValue : Constants.General.EmptyString
        
        status = json[Constants.ResponseParameters.Status].exists() ? json[Constants.ResponseParameters.Status].boolValue : false
        
        organizationId = json[Constants.ResponseParameters.OrganizationId].exists() ? json[Constants.ResponseParameters.OrganizationId].stringValue : Constants.General.EmptyString
        
        role = Role(json[Constants.ResponseParameters.Role])
    }
}
