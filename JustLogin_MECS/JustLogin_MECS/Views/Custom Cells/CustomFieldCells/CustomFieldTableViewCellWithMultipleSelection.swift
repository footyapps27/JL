//
//  CustomFieldTableViewCellWithMultipleSelection.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellWithMultipleSelection: CustomFieldBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtField: UITextField!
    
    var selectedId: String?
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField field: CustomField) {
        if let id = field.values[Constants.CustomFieldKeys.id] {
            selectedId = id
        }
        txtField.text = field.values[Constants.CustomFieldKeys.value]
        
        lblFieldName.text = field.name
    }
    
    override func validateInput(withField field: CustomField) -> (success: Bool, errorMessage: String) {
        if field.isMandatory && txtField.text!.isEmpty {
            return (false, "Please make sure \(field.name) has been entered.")
        }
        
        return(true, Constants.General.emptyString)
    }
    
    override func updateView(withId id: String, value: String) {
        selectedId = id
        txtField.text = value
    }
    
    override func getPayload(withField field: CustomField) -> [String : Any] {
        /*
         If "id" is present, then that is given more preference.
         If not present, then we check we can send the text value or not.
         */
        if selectedId != nil && !(selectedId?.isEmpty)! {
            return [
                field.jsonParameter : selectedId!
            ]
        } else if !(txtField.text!.isEmpty) {
            return [
                field.jsonParameter : txtField.text!
            ]
        }
        
        return [:]
    }
}
