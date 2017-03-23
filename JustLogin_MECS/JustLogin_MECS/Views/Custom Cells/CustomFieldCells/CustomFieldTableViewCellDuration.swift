//
//  CustomFieldTableViewCellDuration.swift
//  JustLogin_MECS
//
//  Created by Samrat on 23/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellDuration: CustomFieldBaseTableViewCell {
    
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var txtTo: UITextField!
    
    /***********************************/
    // MARK: - Parent class override
    /***********************************/
    
    override func validateInput(withField reportField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        // This cell is only used for Duration
        if txtFrom.text!.isEmpty {
            return (false, "Please make sure 'Report To' date has been entered.")
        }
        
        if txtTo.text!.isEmpty {
            return (false, "Please make sure 'Report To' date has been entered.")
        }
        
        return(true, Constants.General.emptyString)
    }
    
    override func getPayload(withField reportField: ExpenseAndReportField) -> [String:Any] {
        return [
            Constants.RequestParameters.Report.startDate : getFormattedDateFromText(txtFrom.text!),
            Constants.RequestParameters.Report.endDate : getFormattedDateFromText(txtTo.text!)
        ]
    }
}
/***********************************/
// MARK: - View lifecylce
/***********************************/
extension CustomFieldTableViewCellDuration {
    override func awakeFromNib() {
        txtTo.tag = ExpenseAndReportFieldType.date.rawValue
        txtFrom.tag = ExpenseAndReportFieldType.date.rawValue
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension CustomFieldTableViewCellDuration {
    func getFormattedDateFromText(_ text: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.localDisplayDateFormat
        
        let formattedDate = dateFormatter.date(from: text)!
        return Utilities.convertDateToStringForServerCommunication(formattedDate)
    }
}
