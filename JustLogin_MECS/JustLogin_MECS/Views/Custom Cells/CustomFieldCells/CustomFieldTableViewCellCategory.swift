//
//  CustomFieldTableViewCellCategory.swift
//  JustLogin_MECS
//
//  Created by Samrat on 23/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellCategory: CustomFieldBaseTableViewCell {
    
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var txtCategory: UITextField!
    
    var selectedCategoryId: String?
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField field: CustomField) {
        if let id = field.values[Constants.CustomFieldKeys.id] {
            selectedCategoryId = id
            imgView.image = UIImage(named: Utilities.getCategoryImageName(forId: id))
        }
        txtCategory.text = field.values[Constants.CustomFieldKeys.value]
    }
    
    override func validateInput(withField field: CustomField) -> (success: Bool, errorMessage: String) {
        if field.isMandatory && txtCategory.text!.isEmpty {
            return (false, "Please make sure 'Category' has been selected.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func updateView(withId id: String, value: String) {
        selectedCategoryId = id
        txtCategory.text = value
        imgView.image = UIImage(named: Utilities.getCategoryImageName(forId: id))
    }
    
    override func getPayload(withField field: CustomField) -> [String : Any] {
        if selectedCategoryId != nil {
            return [
                field.jsonParameter : selectedCategoryId!
            ]
        }
        return [:]
    }
}
/***********************************/
// MARK: - View lifecylce
/***********************************/
extension CustomFieldTableViewCellCategory {
    override func awakeFromNib() {
        imgView.image = UIImage(named: Constants.Defaults.categoryImage)
    }
}
