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
    var id: String?
    
    var decimalPlaces: Int = Constants.Defaults.DecimalPlaces
    
    var format: String?
    
    var symbol: String?
    
    var code: String?
    
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
        
        if json[Constants.ResponseParameters.CurrencyId].exists() {
            id = json[Constants.ResponseParameters.CurrencyId].stringValue
        }
        
        if json[Constants.ResponseParameters.DecimalPlaces].exists() {
            decimalPlaces = json[Constants.ResponseParameters.DecimalPlaces].intValue
        }
        
        if json[Constants.ResponseParameters.Format].exists() {
            format = json[Constants.ResponseParameters.Format].stringValue
        }
        
        if json[Constants.ResponseParameters.Symbol].exists() {
            symbol = json[Constants.ResponseParameters.Symbol].stringValue
        }
        
        if json[Constants.ResponseParameters.Code].exists() {
            code = json[Constants.ResponseParameters.Code].stringValue
        }
    }
}
