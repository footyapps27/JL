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
        id = json[Constants.ResponseParameters.CategoryId].exists() ? json[Constants.ResponseParameters.CategoryId].stringValue : Constants.General.EmptyString
        
        logo = json[Constants.ResponseParameters.Logo].exists() ? json[Constants.ResponseParameters.Logo].intValue : Constants.Defaults.CategoryLogo
        
        name = json[Constants.ResponseParameters.Name].exists() ? json[Constants.ResponseParameters.Name].stringValue : Constants.General.EmptyString
        
        accountCode = json[Constants.ResponseParameters.AccountCode].exists() ? json[Constants.ResponseParameters.AccountCode].stringValue : Constants.General.EmptyString
        
        description = json[Constants.ResponseParameters.Description].exists() ? json[Constants.ResponseParameters.Description].stringValue : Constants.General.EmptyString
        
        isActive = json[Constants.ResponseParameters.IsActive].exists() ? json[Constants.ResponseParameters.IsActive].boolValue : false
    }
}
