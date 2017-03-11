//
//  AddExpenseBaseTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

// TODO: - Make this class to an interface
class AddExpenseBaseTableViewCell: BaseCustomTableViewCell {
    /**
     * Update the view based on the expense field parameters.
     */
    func updateView(withField expenseField: ExpenseAndReportField) {}
    
    /**
     * Update view based on the value selected by the user from the multiple selection table.
     */
    func updateView(withId id: String, value: String) {}
    
    /**
     * Called when the cell is selected.
     * The cell decides which component to make the first responder.
     */
    func makeFirstResponder() {}
    
    /**
     * Validate inputs of the cell based on the report field.
     */
    func validateInput(withField reportField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        return (true, Constants.General.emptyString)
    }
    
    /**
     * Return the payload based on the report field & input value.
     */
    func getPayload(withField reportField: ExpenseAndReportField) -> [String:Any] {
        return [String:Any]()
    }
}
