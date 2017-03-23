//
//  CustomFieldTableViewCellWithLabel.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellWithLabel: CustomFieldBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var lblFieldValue: UILabel!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField field: ExpenseAndReportField) {
        lblFieldName.text = field.name
        lblFieldValue.text = field.value
    }
}
