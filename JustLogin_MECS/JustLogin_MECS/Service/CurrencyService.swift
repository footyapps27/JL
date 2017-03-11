//
//  CurrencyService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 11/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ICurrencyService {
    
    /**
     * Method to retrieve all currencies.
     */
    func getAllCurrencies(_ completionHandler:( @escaping (Result<[Currency]>) -> Void))
    
    /**
     * Create a new currency.
     */
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Currency>) -> Void))
    
    /**
     * Update an existing currency.
     */
    func update(currency: Currency, completionHandler:( @escaping (Result<Currency>) -> Void))
    
    /**
     * Delete an existing currency.
     */
    func delete(currencyId: String, completionHandler:( @escaping (Result<Currency>) -> Void))
}

struct CurrencyService : ICurrencyService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - IExpenseService implementation
    /***********************************/
    func getAllCurrencies(_ completionHandler:( @escaping (Result<[Currency]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.getAllCurrencies, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                var allCurrencies: [Currency] = []
                if let jsonCurrencies = success[Constants.ResponseParameters.currencies] as? [Any] {
                    for currency in jsonCurrencies {
                        allCurrencies.append(Currency(withJSON: JSON(currency)))
                    }
                }
                completionHandler(Result.success(allCurrencies))
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Currency>) -> Void)) {
        
    }
    
    func update(currency: Currency, completionHandler:( @escaping (Result<Currency>) -> Void)) {
        
    }
    
    func delete(currencyId: String, completionHandler:( @escaping (Result<Currency>) -> Void)) {
        
    }
}
