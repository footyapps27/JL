//
//  AddReportTableViewCellWithMultipleSelection.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddReportTableViewCellWithMultipleSelection: AddReportBaseTableViewCell {
    
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtField: UITextField!
    
    /***********************************/
    // MARK: - Parent class override methods
    /***********************************/
    override func validateInput(withField reportField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if reportField.isMandatory {
            if txtField.text!.isEmpty {
                return (false, "Please make sure '\(reportField.name.capitalized)' has been entered.")
            }
        }
        return(true, Constants.General.emptyString)
    }
    
    override func getPayload(withField reportField: ExpenseAndReportField) -> [String:Any] {
        return [reportField.jsonParameter : txtField.text!]
    }
}
