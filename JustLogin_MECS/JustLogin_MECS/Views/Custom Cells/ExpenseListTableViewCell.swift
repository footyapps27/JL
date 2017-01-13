//
//  ExpenseListTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ExpenseListTableViewCell: BaseCustomTableViewCell {
    
    // The name of the report.
    @IBOutlet weak var lblExpenseName: UILabel!
    
    // The total amount (includes the currency code), e.g. $41.00.
    @IBOutlet weak var lblAmount: UILabel!
    
    // The status of the expense.
    @IBOutlet weak var lblStatus: UILabel!
    
    // The date & description.
    @IBOutlet weak var lblDateAndDescription: UILabel!
    
    // Indicator to show that the expense violates company policy
    @IBOutlet weak var imgPolicyViolation: UIImageView!
    
    // Indicator to show that the expense has attachments
    @IBOutlet weak var imgAttachment: UIImageView!
    
    // Indicator to show that the expense has comments
    @IBOutlet weak var imgComment: UIImageView!
}
