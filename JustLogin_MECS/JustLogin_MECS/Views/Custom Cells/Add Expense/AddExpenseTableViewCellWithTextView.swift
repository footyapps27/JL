//
//  AddReportTableViewCellWithTextView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Outlets
/***********************************/
class AddExpenseTableViewCellWithTextView: AddExpenseBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        lblFieldName.text = expenseField.name
    }
    
    override func validateInput(withField expenseField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if expenseField.isMandatory && txtView.text!.isEmpty {
            return (false, "Please make sure '\(expenseField.name)' has been entered.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func makeFirstResponder() {
        txtView.becomeFirstResponder()
    }
    
    override func getPayload(withField expenseField: ExpenseAndReportField) -> [String : Any] {
        return [
            expenseField.jsonParameter : txtView.text!
        ]
    }
}
