//
//  AddReportTableViewCellStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct AddReportTableViewCellFactory {
    
    init(withReportField reportField: ReportField) {
        switch reportField.fieldType {
        case ReportFieldType.text.rawValue:
            print("Text")
        case ReportFieldType.doubleTextField.rawValue:
            print("Text")
        case ReportFieldType.textView.rawValue:
            print("Text")
        default:
            print("Text")
        }
    }
    
}
