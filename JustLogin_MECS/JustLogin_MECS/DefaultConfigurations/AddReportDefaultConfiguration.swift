//
//  AddEditReportDefaultConfiguration.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct AddEditReportDefaultConfiguration {
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    static func getFields() -> [CustomField] {
        var fields: [CustomField] = []
        
        // Mandatory fields
        fields.append(getTitleField())
        fields.append(getDurationField())
        
        // Optional fields
        if getCustomerField() != nil {
            fields.append(getCustomerField()!)
        }
        
        if getProjectField() != nil {
            fields.append(getProjectField()!)
        }
        
        if getBusinessPurposeField() != nil {
            fields.append(getBusinessPurposeField()!)
        }
        
        return fields
    }
}
/***********************************/
// MARK: - Mandatory Fields
/***********************************/
extension AddEditReportDefaultConfiguration {
    
    fileprivate static func getTitleField() -> CustomField {
        var title = CustomField()
        title.name = "Report Title"
        title.jsonParameter = Constants.RequestParameters.Report.title
        title.fieldType = CustomFieldType.text.rawValue
        title.isMandatory = true
        title.isEnabled = true
        
        return title
    }
    
    fileprivate static func getDurationField() -> CustomField {
        var duration = CustomField()
        duration.name = "Duration"
        duration.fieldType = CustomFieldType.doubleTextField.rawValue
        duration.isMandatory = true
        duration.isEnabled = true
        
        return duration
    }
}
/***********************************/
// MARK: - Optional Fields
/***********************************/
extension AddEditReportDefaultConfiguration {
    
    fileprivate static func getCustomerField() -> CustomField? {
        if let customerField = Singleton.sharedInstance.organization?.reportFields["customer"], customerField.isEnabled {
            return customerField
        }
        return nil
    }
    
    fileprivate static func getProjectField() -> CustomField? {
        if let projectField = Singleton.sharedInstance.organization?.reportFields["project"], projectField.isEnabled {
            return projectField
        }
        return nil
    }
    
    fileprivate static func getBusinessPurposeField() -> CustomField? {
        if let businessPurposeField = Singleton.sharedInstance.organization?.reportFields[Constants.RequestParameters.Report.businessPurpose], businessPurposeField.isEnabled {
            return businessPurposeField
        }
        return nil
    }
}
