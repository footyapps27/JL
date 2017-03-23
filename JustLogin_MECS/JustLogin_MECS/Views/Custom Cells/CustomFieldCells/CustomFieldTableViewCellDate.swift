//
//  CustomFieldTableViewCellDate.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellDate: CustomFieldBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var txtDate: UITextField!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField field: ExpenseAndReportField) {
        lblDate.text = field.name
        txtDate.tag = ExpenseAndReportFieldType.date.rawValue
    }
    
    override func validateInput(withField field: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if txtDate.text!.isEmpty {
            return (false, "Please make sure 'Date' has been entered.")
        }
        return(true, Constants.General.emptyString)
    }
    
    override func makeFirstResponder() {
        txtDate.becomeFirstResponder()
    }
    
    override func getPayload(withField field: ExpenseAndReportField) -> [String : Any] {
        return [
            field.jsonParameter : getFormattedDateFromText(txtDate.text!)
        ]
    }
}
/***********************************/
// MARK: - View lifecylce
/***********************************/
extension CustomFieldTableViewCellDate {
    override func awakeFromNib() {
        txtDate.text = Utilities.convertDateToStringForDisplay(Date())
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension CustomFieldTableViewCellDate {
    func getFormattedDateFromText(_ text: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.localDisplayDateFormat
        
        let formattedDate = dateFormatter.date(from: text)!
        
        return Utilities.convertDateToStringForServerCommunication(formattedDate)
    }
}
