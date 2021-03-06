//
//  CustomFieldTableViewCellWithTextView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellWithTextView: CustomFieldBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField field: CustomField) {
        lblFieldName.text = field.name
        txtView.text = field.values[Constants.CustomFieldKeys.value]
    }
    
    override func validateInput(withField field: CustomField) -> (success: Bool, errorMessage: String) {
        if field.isMandatory && txtView.text!.isEmpty {
            return (false, "Please make sure '\(field.name)' has been entered.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func makeFirstResponder() {
        txtView.becomeFirstResponder()
    }
    
    override func getPayload(withField field: CustomField) -> [String : Any] {
        return [
            field.jsonParameter : txtView.text!
        ]
    }
}
