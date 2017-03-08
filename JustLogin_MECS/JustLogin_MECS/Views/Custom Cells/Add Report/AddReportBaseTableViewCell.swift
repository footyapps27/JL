//
//  AddReportBaseTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 1/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit


class AddReportBaseTableViewCell: BaseCustomTableViewCell {
    
    /**
     * Update the view based on the report field parameters.
     */
    func updateView(withReportField reportField: ReportField) {}
    
    /**
     * Called when the cell is selected. 
     * The cell decides which component to make the first responder.
     */
    func makeFirstResponder() {}
    
    /**
     * Validate inputs of the cell based on the report field.
     */
    func validateInput(withReportField reportField: ReportField) -> (success: Bool, errorMessage: String) {
        return (true, Constants.General.emptyString)
    }
    
    /**
     * Return the payload based on the report field & input value.
     */
    func getPayload(withReportField reportField: ReportField) -> [String:Any] {
        return [String:Any]()
    }
}
