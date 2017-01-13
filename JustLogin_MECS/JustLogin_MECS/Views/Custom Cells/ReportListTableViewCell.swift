//
//  ReportListTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportListTableViewCell: BaseCustomTableViewCell {
    
    // The name of the report.
    @IBOutlet weak var lblReportName: UILabel!
    
    // The total amount (includes the currency code), e.g. $ 41.00.
    @IBOutlet weak var lblAmount: UILabel!
    
    // The status of the report.
    @IBOutlet weak var lblStatus: UILabel!
    
    // The date from which this is valid to.
    @IBOutlet weak var lblDate: UILabel!
}
