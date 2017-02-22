//
//  Organization.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Organization {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var id: String?
    
    var name: String?
    
    var baseCurrencyId: String?
    
    var currencies: [String: Currency] = [:]
    
    var categories: [String: Category] = [:]
    
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
        id = json[Constants.ResponseParameters.OrganizationId].exists() ? json[Constants.ResponseParameters.OrganizationId].stringValue : Constants.General.EmptyString
        
        name = json[Constants.ResponseParameters.Name].exists() ? json[Constants.ResponseParameters.Name].stringValue : Constants.General.EmptyString
        
        baseCurrencyId = json[Constants.ResponseParameters.BaseCurrencyId].exists() ? json[Constants.ResponseParameters.BaseCurrencyId].stringValue : Constants.General.EmptyString
        
        let jsonCurrencies = json[Constants.ResponseParameters.Currencies].exists() ? json[Constants.ResponseParameters.Currencies].arrayValue : []
        for jsonCurrency in jsonCurrencies {
            let currency = Currency(withJSON: jsonCurrency)
            currencies[currency.id!] = currency
        }
        
        let jsonCategories = json[Constants.ResponseParameters.Categories].exists() ? json[Constants.ResponseParameters.Categories].arrayValue : []
        for jsonCategory in jsonCategories {
            let category = Category(withJSON: jsonCategory)
            categories[category.id!] = category
        }
    }
}
