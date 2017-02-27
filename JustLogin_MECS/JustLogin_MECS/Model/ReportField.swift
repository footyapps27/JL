//
//  ReportField.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReportField {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var id: String = Constants.General.emptyString
    
    var fieldName: String = Constants.General.emptyString
    
    var fieldType: Int = Constants.Defaults.reportFieldType
    
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
        
    }
}
