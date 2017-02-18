//
//  Currency.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Currency {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let id: String
    
    let decimalPlaces: Int
    
    let format: String
    
    let symbol: String
    
    let code: String
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    init(_ json:JSON) {
        id = json["currencyId"].exists() ? json["currencyId"].stringValue : ""
        
        decimalPlaces = json["decimalPlaces"].exists() ? json["decimalPlaces"].intValue : 2
        
        format = json["format"].exists() ? json["format"].stringValue : ""
        
        symbol = json["symbol"].exists() ? json["symbol"].stringValue : ""
        
        code = json["code"].exists() ? json["code"].stringValue : ""
    }
}
