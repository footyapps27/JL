//
//  ReviewSelectCategoryManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 10/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for ExpenseListViewController
 */
class ReviewSelectCategoryManager {
    
    var categoryService: ICategoryService = CategoryService()
    
    var categories: [Category] = []
    
    init() {
        if let existingCategories = Singleton.sharedInstance.organization?.categories {
            categories = Array(existingCategories.values)
        }
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ReviewSelectCategoryManager {
    func getCategories() -> [Category] {
        return categories
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ReviewSelectCategoryManager {
    
    func getCategoryName(forIndexPath indexPath: IndexPath) -> String {
        return categories[indexPath.row].name
    }
    
    func getCategoryImageName(forIndexPath indexPath: IndexPath) -> String {
        let logo = categories[indexPath.row].logo
        return "Category" + String(logo)
    }
}
/***********************************/
// MARK: - Service Calls
/***********************************/
extension ReviewSelectCategoryManager {
    /**
     * Method to fetch all expenses from the server.
     */
    func fetchCategories(completionHandler: (@escaping (ManagerResponseToController<[Category]>) -> Void)) {
        categoryService.getAllCategories({ [weak self] (result) in
            switch(result) {
            case .success(let categoryList):
                // Store this list in the Singleton & update the category list
                self?.categories = categoryList
                
                Singleton.sharedInstance.organization?.categories = [:]
                
                for category in categoryList {
                    Singleton.sharedInstance.organization?.categories[category.id] = category
                }
                
                completionHandler(ManagerResponseToController.success(categoryList))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
}
