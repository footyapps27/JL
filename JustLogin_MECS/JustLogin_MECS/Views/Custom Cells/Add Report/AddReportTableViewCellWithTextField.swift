
//
//  File.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddReportTableViewCellWithTextField: AddReportBaseTableViewCell {
    
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtField: UITextField!
    
    override func updateView(withReportField reportField: ReportField) {
        lblFieldName.text = reportField.fieldName
    }
}
