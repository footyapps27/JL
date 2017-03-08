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
    
    var fields: [ExpenseAndReportField] = []
    
    var reportService: ReportService = ReportService()
    
    init() {
        updateFields()
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension AddReportManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getReportFields() -> [ExpenseAndReportField] {
        return fields
    }
    
    func getTableViewCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        let reportField = fields[indexPath.row]
        switch reportField.fieldType {
        case ExpenseAndReportFieldType.text.rawValue:
            return Constants.CellIdentifiers.addReportTableViewCellWithTextField
        case ExpenseAndReportFieldType.doubleTextField.rawValue:
            return Constants.CellIdentifiers.addReportTableViewCellDuration
        case ExpenseAndReportFieldType.textView.rawValue:
            return Constants.CellIdentifiers.addReportTableViewCellWithTextView
        case ExpenseAndReportFieldType.dropdown.rawValue:
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
            payload = payload.merged(with: cell.getPayload(withField: fields[index]))
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
        cell.updateView(withField: reportField)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddReportManager {
    func performActionForSelectedCell(_ cell: AddReportBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = getReportFields()[indexPath.row]
        if reportField.fieldType == ExpenseAndReportFieldType.text.rawValue ||
            reportField.fieldType == ExpenseAndReportFieldType.textView.rawValue {
            cell.makeFirstResponder()
        }
    }
    
    func validateInputs(forTableView tableView: UITableView) -> (success: Bool, errorMessage: String) {
        
        var indexPath = IndexPath(item: 0, section: 0)
        
        for index in 0..<fields.count {
            indexPath.row = index
            let cell = tableView.cellForRow(at: indexPath) as! AddReportBaseTableViewCell
            
            let validation = cell.validateInput(withField: fields[index])
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
/***********************************/
// MARK: - Data manipulation
/***********************************/
extension AddReportManager {
    func updateFields() {
        var title = ExpenseAndReportField()
        title.name = "Report Title"
        title.jsonParameter = Constants.RequestParameters.Report.title
        title.fieldType = ExpenseAndReportFieldType.text.rawValue
        title.isMandatory = true
        title.isEnabled = true
        
        var duration = ExpenseAndReportField()
        duration.name = "Duration"
        duration.fieldType = ExpenseAndReportFieldType.doubleTextField.rawValue
        duration.isMandatory = true
        duration.isEnabled = true
        
        // First the title is added
        fields.append(title)
        
        if let customerField = Singleton.sharedInstance.organization?.reportFields["customer"], customerField.isEnabled {
                fields.append(customerField)
        }
        
        if let projectField = Singleton.sharedInstance.organization?.reportFields["project"], projectField.isEnabled {
                fields.append(projectField)
        }
        
        // Add the duration in between
        fields.append(duration)
        
        if let businessPurposeField = Singleton.sharedInstance.organization?.reportFields["businessPurpose"], businessPurposeField.isEnabled {
                fields.append(businessPurposeField)
        }
        
        // Now add all the other fields
        guard let allReportFields = Singleton.sharedInstance.organization?.reportFields.values else {
            return
        }
        
        for reportField in allReportFields {
            // Since the three fields have been added, negate them & add field only if they are enabled.
            if  reportField.jsonParameter != "customer" &&
                reportField.jsonParameter != "project" &&
                reportField.jsonParameter != "businessPurpose" &&
                reportField.isEnabled {
                    fields.append(reportField)
            }
        }
    }
}
