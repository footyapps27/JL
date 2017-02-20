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
    let id: String
    
    let name: String
    
    let baseCurrencyId: String
    
    var currencies: [String: Currency] = [:]
    
    var categories: [String: Category] = [:]
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    init(_ json:JSON) {
        id = json[Constants.ResponseParameters.OrganizationId].exists() ? json[Constants.ResponseParameters.OrganizationId].stringValue : Constants.General.EmptyString
        
        name = json[Constants.ResponseParameters.Name].exists() ? json[Constants.ResponseParameters.Name].stringValue : Constants.General.EmptyString
        
        baseCurrencyId = json[Constants.ResponseParameters.BaseCurrencyId].exists() ? json[Constants.ResponseParameters.BaseCurrencyId].stringValue : Constants.General.EmptyString
        
        let jsonCurrencies = json[Constants.ResponseParameters.Currencies].exists() ? json[Constants.ResponseParameters.Currencies].arrayValue : []
        for jsonCurrency in jsonCurrencies {
            let currency = Currency(jsonCurrency)
            currencies[currency.id] = currency
        }
        
        let jsonCategories = json[Constants.ResponseParameters.Categories].exists() ? json[Constants.ResponseParameters.Categories].arrayValue : []
        for jsonCategory in jsonCategories {
            let category = Category(jsonCategory)
            categories[category.id] = category
        }
    }
}
