//
//  CustomFieldTableViewCellWithTextField.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellWithTextField: CustomFieldBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtField: UITextField!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField field: CustomField) {
        lblFieldName.text = field.name
        txtField.text = field.values[Constants.CustomFieldKeys.value]
    }
    
    override func makeFirstResponder() {
        txtField.becomeFirstResponder()
    }
    
    override func validateInput(withField field: CustomField) -> (success: Bool, errorMessage: String) {
        if field.isMandatory && txtField.text!.isEmpty {
            return (false, "Please make sure '\(field.name)' has been entered.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func getPayload(withField field: CustomField) -> [String : Any] {
        return [
            field.jsonParameter : txtField.text!
        ]
    }
}
