//
//  AddExpenseTableViewCellWithMultipleSelection.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseTableViewCellWithMultipleSelection: AddExpenseBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtField: UITextField!
    
    var selectedId: String?
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        lblFieldName.text = expenseField.name
    }
    
    override func validateInput(withField reportField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if reportField.isMandatory && txtField.text!.isEmpty {
            return (false, "Please make sure \(reportField.name) has been entered.")
        }
        
        return(true, Constants.General.emptyString)
    }
    
    override func updateView(withId id: String, value: String) {
        selectedId = id
        txtField.text = value
    }
    
    override func getPayload(withField reportField: ExpenseAndReportField) -> [String : Any] {
        /* 
         If "id" is present, then that is given more preference.
         If not present, then we check we can send the text value or not.
         */
        if selectedId != nil && !(selectedId?.isEmpty)! {
            return [
                reportField.jsonParameter : selectedId!
            ]
        } else if !(txtField.text!.isEmpty) {
            return [
                reportField.jsonParameter : txtField.text!
            ]
        }
        
        return [:]
    }
}
