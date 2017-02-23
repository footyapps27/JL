//
//  Category.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var id: String?
    
    var logo: Int = Constants.Defaults.CategoryLogo
    
    var name: String?
    
    var accountCode: String?
    
    var description: String?
    
    var isActive: Bool = false
    
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
        
        if json[Constants.ResponseParameters.CategoryId].exists() {
            id = json[Constants.ResponseParameters.CategoryId].stringValue
        }
        
        if json[Constants.ResponseParameters.Logo].exists() {
            logo = json[Constants.ResponseParameters.Logo].intValue
        }
        
        if json[Constants.ResponseParameters.Name].exists() {
            name = json[Constants.ResponseParameters.Name].stringValue
        }
        
        if json[Constants.ResponseParameters.AccountCode].exists() {
            accountCode = json[Constants.ResponseParameters.AccountCode].stringValue
        }
        
        if json[Constants.ResponseParameters.Description].exists() {
            description = json[Constants.ResponseParameters.Description].stringValue
        }
        
        if json[Constants.ResponseParameters.IsActive].exists() {
            isActive = json[Constants.ResponseParameters.IsActive].boolValue
        }
    }
}
