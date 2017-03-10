//
//  AddExpenseDateTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseTableViewCellDate: AddExpenseBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var txtDate: UITextField!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        lblDate.text = expenseField.name
        txtDate.tag = ExpenseAndReportFieldType.date.rawValue
    }
    
    override func validateInput(withField reportField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if txtDate.text!.isEmpty {
            return (false, "Please make sure 'Date' has been entered.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func makeFirstResponder() {
        txtDate.becomeFirstResponder()
    }
}
/***********************************/
// MARK: - View lifecylce
/***********************************/
extension AddExpenseTableViewCellDate {
    override func awakeFromNib() {
        txtDate.text = Utilities.convertDateToStringForDisplay(Date())
    }
}
