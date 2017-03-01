//
//  AddReportTableViewCellWithTextView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddReportTableViewCellWithTextView: AddReportBaseTableViewCell {
    
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    override func updateView(withReportField reportField: ReportField) {
        lblFieldName.text = reportField.fieldName
    }
    
    override func makeFirstResponder() {
        txtView.becomeFirstResponder()
    }
    
    override func validateInput(withReportField reportField: ReportField) -> (success: Bool, errorMessage: String) {
        if reportField.isMandatory {
            if txtView.text!.isEmpty {
                return (false, "Please make sure '\(reportField.fieldName.capitalized)' has been entered.")
            }
        }
        return(true, Constants.General.emptyString)
    }
    
    override func getPayload(withReportField reportField: ReportField) -> [String:Any] {
        return [reportField.jsonParameter : txtView.text!]
    }
}
