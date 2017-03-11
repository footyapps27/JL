//
//  AddExpenseTableViewCellWithTextfield.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseTableViewCellWithTextField: AddExpenseBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtField: UITextField!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        lblFieldName.text = expenseField.name
    }
    
    override func makeFirstResponder() {
        txtField.becomeFirstResponder()
    }
    
    override func validateInput(withField expenseField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if expenseField.isMandatory && txtField.text!.isEmpty {
            return (false, "Please make sure '\(expenseField.name)' has been entered.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func getPayload(withField expenseField: ExpenseAndReportField) -> [String : Any] {
        return [
            expenseField.jsonParameter : txtField.text!
        ]
    }
}
