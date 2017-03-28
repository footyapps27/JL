//
//  RecordReimbursementDefaultConfiguration.swift
//  JustLogin_MECS
//
//  Created by Samrat on 28/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct RecordReimbursementDefaultConfiguration {
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    static func getFields() -> [[CustomField]] {
        var fields: [[CustomField]] = []
        
        fields.append(contentsOf: [getSection0(),
                                   getSection1()])
        
        return fields
    }
}
/***********************************/
// MARK: - Section 0
/***********************************/
extension RecordReimbursementDefaultConfiguration {
    
    fileprivate static func getSection0() -> [CustomField] {
        return ([getAmountField(), getPaidToField()])
    }
    
    private static func getAmountField() -> CustomField {
        var amount = CustomField()
        amount.name = "Amount"
        amount.fieldType = CustomFieldType.label.rawValue
        amount.isMandatory = true
        amount.isEnabled = true
        
        return amount
    }
    
    private static func getPaidToField() -> CustomField {
        var paidTo = CustomField()
        paidTo.name = "Paid To"
        paidTo.fieldType = CustomFieldType.label.rawValue
        paidTo.isMandatory = true
        paidTo.isEnabled = true
        
        return paidTo
    }
}
/***********************************/
// MARK: - Section 1
/***********************************/
extension RecordReimbursementDefaultConfiguration {
    
    fileprivate static func getSection1() -> [CustomField] {
        return ([getDateField(), getPaidThroughField(), getNotesField(), getReferenceNumberField()])
    }
    
    private static func getDateField() -> CustomField {
        var date = CustomField()
        date.name = "Reimbursed Date"
        date.jsonParameter = "reimburseOn"
        date.fieldType = CustomFieldType.date.rawValue
        date.isMandatory = true
        date.isEnabled = true
        
        return date
    }
    
    private static func getPaidThroughField() -> CustomField {
        var paidThrough = CustomField()
        paidThrough.name = "Paid Through"
        paidThrough.fieldType = CustomFieldType.dropdown.rawValue
        paidThrough.jsonParameter = "paidThrough"
        paidThrough.dropdownValues = ["Petty Cash", "Undeposited Funds"]
        paidThrough.isMandatory = false
        paidThrough.isEnabled = true
        
        return paidThrough
    }
    
    private static func getNotesField() -> CustomField {
        var notes = CustomField()
        notes.name = "Notes"
        notes.fieldType = CustomFieldType.textView.rawValue
        notes.jsonParameter = "notes"
        notes.isMandatory = false
        notes.isEnabled = true
        
        return notes
    }
    
    private static func getReferenceNumberField() -> CustomField {
        var referenceNumber = CustomField()
        referenceNumber.name = "Reference #"
        referenceNumber.fieldType = CustomFieldType.text.rawValue
        referenceNumber.jsonParameter = "referenceNumber"
        referenceNumber.isMandatory = false
        referenceNumber.isEnabled = true
        
        return referenceNumber
    }
}
