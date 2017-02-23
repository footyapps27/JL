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
        
        
            id = json[Constants.ResponseParameters.roleId].stringValue
        
            name = json[Constants.ResponseParameters.name].stringValue
        
        
            description = json[Constants.ResponseParameters.description].stringValue
        
        
            isDefault = json[Constants.ResponseParameters.isDefault].boolValue
        
        accessPrivileges = AccessPrivilege(withJSON: json[Constants.ResponseParameters.accessPrivileges])
    }
}
