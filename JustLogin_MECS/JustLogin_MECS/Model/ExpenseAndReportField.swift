//
//  ReportField.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CustomField {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var name: String = Constants.General.emptyString
    
    var jsonParameter: String = Constants.General.emptyString
    
    var fieldType: Int = Constants.Defaults.fieldType
    
    var isMandatory: Bool = false
    
    var isEnabled: Bool = false
    
    var dropdownValues: [String] = []
    
    // This will only be used when we have a value already set for the field.
    var values: [String : String] = [:]
    
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
        
        fieldType = json[Constants.ResponseParameters.dataType].intValue
        
        isEnabled = json[Constants.ResponseParameters.isEnabled].boolValue
        
        isMandatory = json[Constants.ResponseParameters.isMandatory].boolValue
    }
}
