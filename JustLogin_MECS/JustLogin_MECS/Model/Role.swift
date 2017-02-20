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
        
        id = json[Constants.ResponseParameters.RoleId].exists() ? json[Constants.ResponseParameters.RoleId].stringValue : Constants.General.EmptyString
        
        name = json[Constants.ResponseParameters.Name].exists() ? json[Constants.ResponseParameters.Name].stringValue : Constants.General.EmptyString
        
        description = json[Constants.ResponseParameters.Description].exists() ? json[Constants.ResponseParameters.Description].stringValue : Constants.General.EmptyString
        
        isDefault = json[Constants.ResponseParameters.IsDefault].exists() ? json[Constants.ResponseParameters.IsDefault].boolValue : false
        
        accessPrivileges = AccessPrivilege(withJSON: json[Constants.ResponseParameters.AccessPrivileges])
    }
}
