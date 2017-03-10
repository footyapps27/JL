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
}
/***********************************/
// MARK: - View lifecylce
/***********************************/
extension AddExpenseTableViewCellCategory {
    override func awakeFromNib() {
        imgView.image = UIImage(named: "Category8")// TODO - Move to Constants
    }
}
