//
//  CategoryService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 10/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ICategoryService {
    
    /**
     * Method to retrieve all categories.
     */
    func getAllCategories(_ completionHandler:( @escaping (Result<[Category]>) -> Void))
    
    /**
     * Create a new category.
     */
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Category>) -> Void))
    
    /**
     * Update an existing category.
     */
    func update(category: Category, completionHandler:( @escaping (Result<Category>) -> Void))
    
    /**
     * Delete an existing category.
     */
    func delete(categoryId: String, completionHandler:( @escaping (Result<Category>) -> Void))
}

struct CategoryService : ICategoryService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - IExpenseService implementation
    /***********************************/
    func getAllCategories(_ completionHandler:( @escaping (Result<[Category]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Category.getAllCategories, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                var allCategories: [Category] = []
                if let jsonCategories = success[Constants.ResponseParameters.categories] as? [Any] {
                    for category in jsonCategories {
                        allCategories.append(Category(withJSON: JSON(category)))
                    }
                }
                completionHandler(Result.success(allCategories))
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Category>) -> Void)) {
        
    }
    
    func update(category: Category, completionHandler:( @escaping (Result<Category>) -> Void)) {
        
    }
    
    func delete(categoryId: String, completionHandler:( @escaping (Result<Category>) -> Void)) {
        
    }
}
    
    
