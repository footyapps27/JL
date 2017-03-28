//
//  AddExpenseDefaultConfiguration.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct AddExpenseDefaultConfiguration {
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    static func getFields() -> [[CustomField]] {
        var fields: [[CustomField]] = []
        
        fields.append(contentsOf: [getSection0(),
                                   getSection1(),
                                   getSection2(),
                                   getSection3(),
                                   getSection4()])
        
        return fields
    }
}
/***********************************/
// MARK: - Section 0
/***********************************/
extension AddExpenseDefaultConfiguration {
    
    fileprivate static func getSection0() -> [CustomField] {
        return ([getCategoryField(), getDateField(), getCurrencyAndAmountField()])
    }
    
    private static func getCategoryField() -> CustomField {
        var categoryField = CustomField()
        categoryField.name = "Category"
        categoryField.jsonParameter = Constants.RequestParameters.Expense.categoryId
        categoryField.fieldType = CustomFieldType.category.rawValue
        categoryField.isMandatory = true
        categoryField.isEnabled = true
        
        return categoryField
    }
    
    private static func getDateField() -> CustomField {
        var dateField = CustomField()
        dateField.name = "Date"
        dateField.jsonParameter = Constants.RequestParameters.Expense.date
        dateField.fieldType = CustomFieldType.date.rawValue
        dateField.isMandatory = true
        dateField.isEnabled = true
        
        return dateField
    }
    
    private static func getCurrencyAndAmountField() -> CustomField {
        var currencyAndAmountField = CustomField()
        currencyAndAmountField.fieldType = CustomFieldType.currencyAndAmount.rawValue
        currencyAndAmountField.isMandatory = true
        currencyAndAmountField.isEnabled = true
        // By default choose the base currency id
        if let baseCurrencyId = Singleton.sharedInstance.organization?.baseCurrencyId {
            currencyAndAmountField.values[Constants.CustomFieldKeys.id] = baseCurrencyId
            currencyAndAmountField.values[Constants.CustomFieldKeys.value] = Utilities.getCurrencyCode(forId: baseCurrencyId)
        }
        return currencyAndAmountField
    }
}
/***********************************/
// MARK: - Section 1
/***********************************/
extension AddExpenseDefaultConfiguration {
    fileprivate static func getSection1() -> [CustomField] {
        if getPaymentModeField() != nil {
            return ([getPaymentModeField()!])
        }
        return []
    }
    
    private static func getPaymentModeField() -> CustomField? {
        if let paymentModeField = Singleton.sharedInstance.organization?.expenseFields[Constants.RequestParameters.CustomFieldJsonParameters.paymentMode], paymentModeField.isEnabled {
            return paymentModeField
        }
        return nil
    }
}
/***********************************/
// MARK: - Section 2
/***********************************/
extension AddExpenseDefaultConfiguration {
    fileprivate static func getSection2() -> [CustomField] {
        var section2: [CustomField] = []
        if getMerchantNameField() != nil {
            section2.append(getMerchantNameField()!)
        }
        
        if getReferenceNumberField() != nil {
            section2.append(getReferenceNumberField()!)
        }
        
        if getLocationField() != nil {
            section2.append(getLocationField()!)
        }
        
        if getDescriptionField() != nil {
            section2.append(getDescriptionField()!)
        }
        return section2
    }
    
    private static func getMerchantNameField() -> CustomField? {
        if let merchantNameField = Singleton.sharedInstance.organization?.expenseFields[Constants.RequestParameters.CustomFieldJsonParameters.merchant], merchantNameField.isEnabled {
            return merchantNameField
        }
        return nil
    }
    
    private static func getReferenceNumberField() -> CustomField? {
        if let referenceNumberField = Singleton.sharedInstance.organization?.expenseFields[Constants.RequestParameters.CustomFieldJsonParameters.reference], referenceNumberField.isEnabled {
            return referenceNumberField
        }
        return nil
    }
    
    private static func getLocationField() -> CustomField? {
        if let locationField = Singleton.sharedInstance.organization?.expenseFields[Constants.RequestParameters.CustomFieldJsonParameters.location], locationField.isEnabled {
            return locationField
        }
        return nil
    }
    
    private static func getDescriptionField() -> CustomField? {
        if let descriptionField = Singleton.sharedInstance.organization?.expenseFields[Constants.RequestParameters.CustomFieldJsonParameters.description], descriptionField.isEnabled {
            return descriptionField
        }
        return nil
    }
}
/***********************************/
// MARK: - Section 3
/***********************************/
extension AddExpenseDefaultConfiguration {
    fileprivate static func getSection3() -> [CustomField] {
        var section3: [CustomField] = []
        if getIsBillableField() != nil {
            section3.append(getIsBillableField()!)
        }
        
        if getCustomerField() != nil {
            section3.append(getCustomerField()!)
        }
        
        if getProjectField() != nil {
            section3.append(getProjectField()!)
        }
        
        section3.append(getAddToReportField())// This is a mandatory field
        return section3
    }
    
    private static func getIsBillableField() -> CustomField? {
        if let isBillableField = Singleton.sharedInstance.organization?.expenseFields["isBillable"], isBillableField.isEnabled {
            return isBillableField
        }
        return nil
    }
    
    private static func getCustomerField() -> CustomField? {
        if let customerField = Singleton.sharedInstance.organization?.expenseFields["customer"], customerField.isEnabled {
            return customerField
        }
        return nil
    }
    
    private static func getProjectField() -> CustomField? {
        if let projectField = Singleton.sharedInstance.organization?.expenseFields["project"], projectField.isEnabled {
            return projectField
        }
        return nil
    }
    
    private static func getAddToReportField() -> CustomField {
        var addToReport = CustomField()
        addToReport.name = "Add to Report"
        addToReport.jsonParameter = Constants.RequestParameters.Expense.reportId
        addToReport.fieldType = CustomFieldType.dropdown.rawValue
        addToReport.isMandatory = false
        addToReport.isEnabled = true
        
        return addToReport
    }
}
/***********************************/
// MARK: - Section 4
/***********************************/
extension AddExpenseDefaultConfiguration {
    fileprivate static func getSection4() -> [CustomField] {
        return ([getAttachImageField()])
    }
    
    private static func getAttachImageField() -> CustomField {
        var attachImage = CustomField()
        attachImage.fieldType = CustomFieldType.imageSelection.rawValue
        attachImage.isMandatory = true
        attachImage.isEnabled = true
        
        return attachImage
    }
}
