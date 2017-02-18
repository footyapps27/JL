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
        id = json["organizationId"].exists() ? json["organizationId"].stringValue : ""
        
        name = json["name"].exists() ? json["name"].stringValue : ""
        
        baseCurrencyId = json["baseCurrencyId"].exists() ? json["baseCurrencyId"].stringValue : ""
        
        let jsonCurrencies = json["currencies"].exists() ? json["currencies"].arrayValue : []
        for jsonCurrency in jsonCurrencies {
            let currency = Currency(jsonCurrency)
            currencies[currency.id] = currency
        }
        
        let jsonCategories = json["categories"].exists() ? json["categories"].arrayValue : []
        for jsonCategory in jsonCategories {
            let category = Category(jsonCategory)
            categories[category.id] = category
        }
    }
}
