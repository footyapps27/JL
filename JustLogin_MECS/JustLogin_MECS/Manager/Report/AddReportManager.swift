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
        title.jsonParameter = Constants.RequestParameters.Report.title
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
        businessPurpose.jsonParameter = Constants.RequestParameters.Report.businessPurpose
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
    
    func getPayload(fromTableView tableView: UITableView) -> [String: Any] {
        var payload = [String:Any]()
        
        var indexPath = IndexPath(item: 0, section: 0)
        
        for index in 0..<fields.count {
            indexPath.row = index
            let cell = tableView.cellForRow(at: indexPath) as! AddReportBaseTableViewCell
            payload = payload.merged(with: cell.getPayload(withReportField: fields[index]))
        }
        return payload
    }
}
/***********************************/
// MARK: - UI updating
/***********************************/
extension AddReportManager {
    
    func formatCell(_ cell: AddReportBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = fields[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateView(withReportField: reportField)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddReportManager {
    func performActionForSelectedCell(_ cell: AddReportBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = getReportFields()[indexPath.row]
        if reportField.fieldType == ReportFieldType.text.rawValue ||
            reportField.fieldType == ReportFieldType.textView.rawValue {
            cell.makeFirstResponder()
        }
    }
    
    func validateInputs(forTableView tableView: UITableView) -> (success: Bool, errorMessage: String) {
        
        var indexPath = IndexPath(item: 0, section: 0)
        
        for index in 0..<fields.count {
            indexPath.row = index
            let cell = tableView.cellForRow(at: indexPath) as! AddReportBaseTableViewCell
            
            let validation = cell.validateInput(withReportField: fields[index])
            if !validation.success {
                return validation
            }
        }
        return (true, Constants.General.emptyString)
    }
}
/***********************************/
// MARK: - Services
/***********************************/
extension AddReportManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func addReportWithInputsFromTableView( tableView: UITableView, completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        let payload = getPayload(fromTableView: tableView)
        
        reportService.create(payload: payload) { (result) in
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
