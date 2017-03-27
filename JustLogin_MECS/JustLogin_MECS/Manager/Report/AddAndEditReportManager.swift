//
//  AddReportManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddAndEditReportManager {
    
    var report: Report? {
        didSet {
            updateFieldValues(forReport: report!)
        }
    }
    
    var fields: [CustomField] = []
    
    var reportService = ReportService()
    
    var dictCells: [IndexPath:CustomFieldBaseTableViewCell] = [:]
    
    init() {
        updateFields()
    }
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension AddAndEditReportManager {
    /**
     * Populate the cells from the table view.
     */
    func populateCells(fromController controller: BaseViewControllerWithTableView, dataSource: UITableViewDataSource) {
            for row in 0..<fields.count {
                let indexPath = IndexPath(row: row, section: 0)
                let cell = dataSource.tableView(controller.tableView, cellForRowAt: indexPath) as! CustomFieldBaseTableViewCell
                dictCells[indexPath] = cell
            }
    }
    
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getReportFields() -> [CustomField] {
        return fields
    }
    
    /**
     * Get the existing cells that have already been populated before.
     */
    func getExistingCells() -> [IndexPath:CustomFieldBaseTableViewCell] {
        return dictCells
    }
    
    func getTableViewCellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        let reportField = fields[indexPath.row]
        switch reportField.fieldType {
        case CustomFieldType.text.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextFieldIdentifier
        case CustomFieldType.doubleTextField.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellDurationIdentifier
        case CustomFieldType.textView.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextViewIdentifier
        case CustomFieldType.dropdown.rawValue:
            return Constants.CellIdentifiers.customFieldTableViewCellWithMultipleSelectionIdentifier
        default:
            return Constants.CellIdentifiers.customFieldTableViewCellWithTextFieldIdentifier
        }
    }
    
    func getPayload() -> [String: Any] {
        var payload = [String:Any]()
        
        for (indexPath,cell) in dictCells {
            payload = payload.merged(with: cell.getPayload(withField: fields[indexPath.row]))
        }
        
        return payload
    }
}
/***********************************/
// MARK: - UI updating
/***********************************/
extension AddAndEditReportManager {
    
    func formatCell(_ cell: CustomFieldBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        let reportField = fields[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateView(withField: reportField)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddAndEditReportManager {
    func performActionForSelectedCell(_ cell: CustomFieldBaseTableViewCell, forIndexPath indexPath: IndexPath) {
        cell.makeFirstResponder()
    }
    
    func validateInputs() -> (success: Bool, errorMessage: String) {
        for (indexPath, cell) in dictCells {
            let validation = cell.validateInput(withField: fields[indexPath.row])
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
extension AddAndEditReportManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func addReport(completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        let payload = getPayload()
        
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
    
    func updateReport(completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        
        // For edit, the manager needs to add the 'id' of the report that is being edited.
        var payload = getPayload()
        payload[Constants.RequestParameters.Report.reportId] = report!.id
        
        reportService.update(payload: payload) { (result) in
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
// MARK: - Helpers
/***********************************/
extension AddAndEditReportManager {
    /**
     * This method will update the field value that is present in the existing report.
     * The value will be then passed to the cells, which will use them to update its view.
     */
    func updateFieldValues(forReport report: Report) {
        for index in fields.indices {
            
            // Title
            if fields[index].jsonParameter == Constants.RequestParameters.Report.title {
                fields[index].values[Constants.CustomFieldKeys.value] = report.title
                continue
            }
            
            // Duration
            if fields[index].name == "Duration" {
                if let startDate = report.startDate {
                    fields[index].values[Constants.CustomFieldKeys.startDateValue] = Utilities.convertDateToStringForDisplay(startDate)
                }
                if let endDate = report.endDate {
                    fields[index].values[Constants.CustomFieldKeys.endDateValue] = Utilities.convertDateToStringForDisplay(endDate)
                }
                continue
            }
            
            // Business Purpose
            if fields[index].jsonParameter == Constants.RequestParameters.Report.businessPurpose {
                fields[index].values[Constants.CustomFieldKeys.value] = report.businessPurpose
                continue
            }
        }
    }
}
/***********************************/
// MARK: - Data manipulation
/***********************************/
extension AddAndEditReportManager {
    func updateFields() {
        var title = CustomField()
        title.name = "Report Title"
        title.jsonParameter = Constants.RequestParameters.Report.title
        title.fieldType = CustomFieldType.text.rawValue
        title.isMandatory = true
        title.isEnabled = true
        
        var duration = CustomField()
        duration.name = "Duration"
        duration.fieldType = CustomFieldType.doubleTextField.rawValue
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
        
        if let businessPurposeField = Singleton.sharedInstance.organization?.reportFields[Constants.RequestParameters.Report.businessPurpose], businessPurposeField.isEnabled {
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
