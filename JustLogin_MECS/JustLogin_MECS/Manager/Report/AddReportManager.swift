//
//  AddReportManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddReportManager {
    
    var fields: [ReportField] = []
    
    var reportService: ReportService = ReportService()
    
    // TODO - This has been hardcoded for now. Needs to be read from server for v2.x
    // Make sure that only enabled fields are filtered out & stored in the array.
    init() {
        var title = ReportField()
        title.fieldName = "Report Title"
        title.fieldType = ReportFieldType.text.rawValue
        title.isMandatory = true
        title.isEnabled = true
        
        var duration = ReportField()
        duration.fieldName = "Duration"
        duration.fieldType = ReportFieldType.doubleTextField.rawValue
        duration.isMandatory = true
        duration.isEnabled = true
        
        var businessPurpose = ReportField()
        businessPurpose.fieldName = "Business Purpose"
        businessPurpose.fieldType = ReportFieldType.textView.rawValue
        businessPurpose.isMandatory = false
        businessPurpose.isEnabled = true
        
        fields.append(title)
        fields.append(duration)
        fields.append(businessPurpose)
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension AddReportManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getReportFields() -> [ReportField] {
        return fields
    }
}
/***********************************/
// MARK: - UI updating
/***********************************/
extension AddReportManager {
    
    func getTableViewCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        let reportField = fields[indexPath.row]
        switch reportField.fieldType {
        case ReportFieldType.text.rawValue:
            return Constants.CellIdentifiers.addReportTableViewCellWithTextField
        case ReportFieldType.doubleTextField.rawValue:
            return Constants.CellIdentifiers.addReportTableViewCellDuration
        case ReportFieldType.textView.rawValue:
            return Constants.CellIdentifiers.addReportTableViewCellWithTextView
        case ReportFieldType.dropdown.rawValue:
            return Constants.CellIdentifiers.addReportTableViewCellWithMultipleSelection
        default:
            return Constants.CellIdentifiers.addReportTableViewCellWithTextField
        }
    }
    
    func formatCell(_ cell: AddReportBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = fields[indexPath.row]
        cell.updateView(withReportField: reportField)
    }
}
/***********************************/
// MARK: - Services
/***********************************/
extension AddReportManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func addReport(_ report: Report, completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        reportService.create(report: report) { (result) in
            switch(result) {
            case .success(_):
                completionHandler(ManagerResponseToController.success())
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message))
            }
        }
    }
}
