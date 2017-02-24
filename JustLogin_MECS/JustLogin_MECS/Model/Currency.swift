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
    var id: String = Constants.General.emptyString
    
    var decimalPlaces: Int = Constants.Defaults.decimalPlaces
    
    var format: String = Constants.General.emptyString
    
    var symbol: String = Constants.General.emptyString
    
    var code: String = Constants.General.emptyString
    
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
        
        id = json[Constants.ResponseParameters.currencyId].stringValue
        
        decimalPlaces = json[Constants.ResponseParameters.decimalPlaces].intValue
        
        format = json[Constants.ResponseParameters.format].stringValue
        
        symbol = json[Constants.ResponseParameters.symbol].stringValue
        
        code = json[Constants.ResponseParameters.code].stringValue
    }
}
