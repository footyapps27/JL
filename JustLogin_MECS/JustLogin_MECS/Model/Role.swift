//
//  Role.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Role {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var id: String?
    
    var name: String?
    
    var description: String?
    
    var isDefault: Bool = false
    
    var accessPrivileges: AccessPrivilege?
    
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
        
        if json[Constants.ResponseParameters.RoleId].exists() {
            id = json[Constants.ResponseParameters.RoleId].stringValue
        }
        
        if json[Constants.ResponseParameters.Name].exists() {
            name = json[Constants.ResponseParameters.Name].stringValue
        }
        
        if json[Constants.ResponseParameters.Description].exists() {
            description = json[Constants.ResponseParameters.Description].stringValue
        }
        
        if json[Constants.ResponseParameters.IsDefault].exists() {
            isDefault = json[Constants.ResponseParameters.IsDefault].boolValue
        }
        
        accessPrivileges = AccessPrivilege(withJSON: json[Constants.ResponseParameters.AccessPrivileges])
    }
}
