//
//  CustomFieldBaseTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class CustomFieldBaseTableViewCell: BaseCustomTableViewCell {
    /**
     * Update the view based on the expense field parameters.
     */
    func updateView(withField field: CustomField) {}
    
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
     * Validate inputs of the cell based on the field.
     */
    func validateInput(withField field: CustomField) -> (success: Bool, errorMessage: String) {
        return (true, Constants.General.emptyString)
    }
    
    /**
     * Return the payload based on the field & input value.
     */
    func getPayload(withField field: CustomField) -> [String:Any] {
        return [String:Any]()
    }
}
