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
    var id: String = Constants.General.emptyString
    
    var name: String = Constants.General.emptyString
    
    var baseCurrencyId: String = Constants.General.emptyString
    
    var currencies: [String: Currency] = [:]
    
    var categories: [String: Category] = [:]
    
    var expenseFields: [String: CustomField] = [:] // The json parameter will be the key
    
    var reportFields: [String: CustomField] = [:] // The json parameter will be the key
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
        
        
        id = json[Constants.ResponseParameters.organizationId].stringValue
        
        name = json[Constants.ResponseParameters.name].stringValue
        
        baseCurrencyId = json[Constants.ResponseParameters.baseCurrencyId].stringValue
        
        let jsonCurrencies = json[Constants.ResponseParameters.currencies].exists() ? json[Constants.ResponseParameters.currencies].arrayValue : []
        for jsonCurrency in jsonCurrencies {
            let currency = Currency(withJSON: jsonCurrency)
            currencies[currency.id] = currency
        }
        
        let jsonCategories = json[Constants.ResponseParameters.categories].exists() ? json[Constants.ResponseParameters.categories].arrayValue : []
        for jsonCategory in jsonCategories {
            let category = Category(withJSON: jsonCategory)
            categories[category.id] = category
        }
        
        let jsonExpenseFields = json[Constants.ResponseParameters.expenseCustomFields].exists() ? json[Constants.ResponseParameters.expenseCustomFields].arrayValue : []
        for jsonExpenseField in jsonExpenseFields {
            let expenseField = CustomField(withJSON: jsonExpenseField)
            expenseFields[expenseField.jsonParameter] = expenseField
        }
        
        let jsonReportFields = json[Constants.ResponseParameters.reportCustomFields].exists() ? json[Constants.ResponseParameters.reportCustomFields].arrayValue : []
        for jsonReportField in jsonReportFields {
            let reportField = CustomField(withJSON: jsonReportField)
            reportFields[reportField.jsonParameter] = reportField
        }
    }
}
