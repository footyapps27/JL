//
//  ReportField.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ExpenseAndReportField {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var name: String = Constants.General.emptyString
    
    var jsonParameter: String = Constants.General.emptyString
    
    var fieldType: Int = Constants.Defaults.fieldType
    
    var isMandatory: Bool = false
    
    var isEnabled: Bool = false
    
    var dropdownValues: [String] = []
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    
    /**
     * Default initializer
     */
    init() {
        
    }
    
    /**
     * Initialize using the JSON object received from the server.
     */
    init(withJSON json:JSON) {
        name = json[Constants.ResponseParameters.name].stringValue
        
        jsonParameter = json[Constants.ResponseParameters.fieldName].stringValue
        
        fieldType = json[Constants.ResponseParameters.datatype].intValue
        
        isEnabled = json[Constants.ResponseParameters.isEnabled].boolValue
        
        isMandatory = json[Constants.ResponseParameters.isEnabled].boolValue
    }
}
