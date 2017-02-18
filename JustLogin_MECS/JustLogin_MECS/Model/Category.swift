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
        id = json["categoryId"].exists() ? json["categoryId"].stringValue : ""
        logo = json["logo"].exists() ? json["logo"].intValue : 0
        name = json["name"].exists() ? json["name"].stringValue : ""
        accountCode = json["accountCode"].exists() ? json["accountCode"].stringValue : ""
        description = json["description"].exists() ? json["description"].stringValue : ""
        isActive = json["isActive"].exists() ? json["isActive"].boolValue : false
    }
}
