//
//  ReviewSelectCategoryManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 10/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
/**
 * Manager for ReviewSelectCategoryViewController
 */
class ReviewSelectCategoryManager {
    
    var categoryService: ICategoryService = ServiceFactory.getCategoryService()
    
    var categories: [Category] = []
    
    init() {
        if let existingCategories = Singleton.sharedInstance.organization?.categories {
            categories = Array(existingCategories.values)
            sortCategoryListByName()
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
        let category = categories[indexPath.row]
        return Utilities.getCategoryImageName(forId: category.id)
    }
    
    func getCellAccessoryType(forIndexPath indexPath: IndexPath, preSelectedCategory: Category?) -> UITableViewCellAccessoryType {
        let category = categories[indexPath.row]
        if preSelectedCategory?.id == category.id {
            return UITableViewCellAccessoryType.checkmark
        }
        return UITableViewCellAccessoryType.none
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
                self?.sortCategoryListByName()
                
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
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReviewSelectCategoryManager {
    func sortCategoryListByName() {
        categories = categories.sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
