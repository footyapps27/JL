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
    
    var logo: Int = Constants.Defaults.categoryLogo
    
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
        
        id = json[Constants.ResponseParameters.categoryId].stringValue
        
        logo = json[Constants.ResponseParameters.logo].intValue
        
        name = json[Constants.ResponseParameters.name].stringValue
        
        accountCode = json[Constants.ResponseParameters.accountCode].stringValue
        
        description = json[Constants.ResponseParameters.description].stringValue
        
        isActive = json[Constants.ResponseParameters.isActive].boolValue
    }
}
