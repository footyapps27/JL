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
        id = json[Constants.ResponseParameters.CurrencyId].exists() ? json[Constants.ResponseParameters.CurrencyId].stringValue : Constants.General.EmptyString
        
        decimalPlaces = json[Constants.ResponseParameters.DecimalPlaces].exists() ? json[Constants.ResponseParameters.DecimalPlaces].intValue : Constants.Defaults.DecimalPlaces
        
        format = json[Constants.ResponseParameters.Format].exists() ? json[Constants.ResponseParameters.Format].stringValue : ""
        
        symbol = json[Constants.ResponseParameters.Symbol].exists() ? json[Constants.ResponseParameters.Symbol].stringValue : Constants.General.EmptyString
        
        code = json[Constants.ResponseParameters.Code].exists() ? json[Constants.ResponseParameters.Code].stringValue : Constants.General.EmptyString
    }
}
