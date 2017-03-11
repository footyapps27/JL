//
//  AddExpenseCategoryTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseTableViewCellCategory: AddExpenseBaseTableViewCell {
    
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var txtCategory: UITextField!
    
    var selectedCategoryId: String?
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        
    }
    
    override func validateInput(withField reportField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if txtCategory.text!.isEmpty {
            return (false, "Please make sure 'Category' has been selected.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func updateView(withId id: String, value: String) {
        selectedCategoryId = id
        txtCategory.text = value
        imgView.image = UIImage(named: Utilities.getCategoryImageName(forId: id))
    }
    
    override func getPayload(withField reportField: ExpenseAndReportField) -> [String : Any] {
        if selectedCategoryId != nil {
            return [
                Constants.RequestParameters.Expense.categoryId : selectedCategoryId!
            ]
        }
        return [:]
    }
}
/***********************************/
// MARK: - View lifecylce
/***********************************/
extension AddExpenseTableViewCellCategory {
    override func awakeFromNib() {
        imgView.image = UIImage(named: Constants.Defaults.categoryImage)
    }
}
