//
//  AddExpenseTableViewCellWithTextfield.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseTableViewCellWithTextField: AddExpenseBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtField: UITextField!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        lblFieldName.text = expenseField.name
    }
}
