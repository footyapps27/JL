//
//  AddReportBaseTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 1/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

// TODO: - Make this class to an interface
class AddReportBaseTableViewCell: BaseCustomTableViewCell {
    
    func updateView(withReportField reportField: ReportField) {}
    
    func makeFirstResponder() {}
    
    func validateInput(withReportField reportField: ReportField) -> (success: Bool, errorMessage: String) {
        return (true, Constants.General.emptyString)
    }
    
    func getPayload(withReportField reportField: ReportField) -> [String:Any] {
        return [String:Any]()
    }
}
