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
    let id: String
    
    let logo: Int
    
    let name: String
    
    let accountCode: String
    
    let description: String
    
    let isActive: Bool
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    init(_ json:JSON) {
        id = json[Constants.ResponseParameters.CategoryId].exists() ? json[Constants.ResponseParameters.CategoryId].stringValue : Constants.General.EmptyString
        
        logo = json[Constants.ResponseParameters.Logo].exists() ? json[Constants.ResponseParameters.Logo].intValue : 0
        
        name = json[Constants.ResponseParameters.Name].exists() ? json[Constants.ResponseParameters.Name].stringValue : Constants.General.EmptyString
        
        accountCode = json[Constants.ResponseParameters.AccountCode].exists() ? json[Constants.ResponseParameters.AccountCode].stringValue : Constants.General.EmptyString
        
        description = json[Constants.ResponseParameters.Description].exists() ? json[Constants.ResponseParameters.Description].stringValue : Constants.General.EmptyString
        
        isActive = json[Constants.ResponseParameters.IsActive].exists() ? json[Constants.ResponseParameters.IsActive].boolValue : false
    }
}
