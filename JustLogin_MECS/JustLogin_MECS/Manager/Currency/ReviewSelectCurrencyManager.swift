//
//  ReviewSelectCurrencyManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 11/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
/**
 * Manager for ReviewSelectCategoryViewController
 */
class ReviewSelectCurrencyManager {
    
    var currencyService: ICurrencyService = ServiceConfiguration.getCurrencyService()
    
    var currencies: [Currency] = []
    
    init() {
        if let existingCurrencies = Singleton.sharedInstance.organization?.currencies {
            currencies = Array(existingCurrencies.values)
            sortCurrenciesByCode()
        }
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ReviewSelectCurrencyManager {
    func getCurrencies() -> [Currency] {
        return currencies
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ReviewSelectCurrencyManager {
    
    func getCurrencyCode(forIndexPath indexPath: IndexPath) -> String {
        return currencies[indexPath.row].code
    }
    
    func getCellAccessoryType(forIndexPath indexPath: IndexPath, preSelectedCurrency: Currency?) -> UITableViewCellAccessoryType {
        let currency = currencies[indexPath.row]
        if preSelectedCurrency?.code == currency.code {
            return UITableViewCellAccessoryType.checkmark
        }
        return UITableViewCellAccessoryType.none
    }
}
/***********************************/
// MARK: - Service Calls
/***********************************/
extension ReviewSelectCurrencyManager {
    /**
     * Method to fetch all expenses from the server.
     */
    func fetchCurrencies(completionHandler: (@escaping (ManagerResponseToController<[Currency]>) -> Void)) {
        currencyService.getAllCurrencies({ [weak self] (result) in
            switch(result) {
            case .success(let currencyList):
                // Store this list in the Singleton & update the category list
                self?.currencies = currencyList
                self?.sortCurrenciesByCode()
                
                Singleton.sharedInstance.organization?.currencies = [:]
                
                for currency in currencyList {
                    Singleton.sharedInstance.organization?.currencies[currency.id] = currency
                }
                
                completionHandler(ManagerResponseToController.success(currencyList))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReviewSelectCurrencyManager {
    func sortCurrenciesByCode() {
        currencies = currencies.sorted(by: { $0.code.localizedCaseInsensitiveCompare($1.code) == ComparisonResult.orderedAscending })
    }
}
