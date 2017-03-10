//
//  AddReportTableViewCellWithTextView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Outlets
/***********************************/
class AddExpenseTableViewCellWithTextView: AddExpenseBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        lblFieldName.text = expenseField.name
    }
    
    override func makeFirstResponder() {
        txtView.becomeFirstResponder()
    }
}
