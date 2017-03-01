//
//  AddReportTableViewCellDuration.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddReportTableViewCellDuration: AddReportBaseTableViewCell {
    
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var txtTo: UITextField!
    
    override func updateView(withReportField reportField: ReportField) {
        txtTo.tag = ReportFieldType.date.rawValue
        txtFrom.tag = ReportFieldType.date.rawValue
    }
    
    override func validateInput(withReportField reportField: ReportField) -> (Bool, String) {
        // This cell is only used for Duration
        if txtFrom.text!.isEmpty {
            return (false, "Please make sure 'Report To' date has been entered.")
        }
        
        if txtTo.text!.isEmpty {
            return (false, "Please make sure 'Report To' date has been entered.")
        }
        
        return(true, Constants.General.emptyString)
    }
}
