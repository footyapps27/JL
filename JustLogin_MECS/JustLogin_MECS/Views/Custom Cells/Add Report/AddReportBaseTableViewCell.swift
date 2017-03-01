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
    
    func updateView(withReportField reportField: ReportField) {}
    
    func makeFirstResponder() {}
    
    func validateInput(withReportField reportField: ReportField) -> (Bool, String) {
        return (true, Constants.General.emptyString)
    }
}
