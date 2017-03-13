//
//  ReportDetailsHeaderView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Properties
/***********************************/
class ReportDetailsHeaderView: UIView {
    
    @IBOutlet weak var lblReportTitle: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblReportStartAndEndDate: UILabel!
    
    @IBOutlet weak var lblReportDuration: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
}
/***********************************/
// MARK: - UI update methods
/***********************************/
extension ReportDetailsHeaderView {
    func updateView(withManager manager: ReportDetailsManager) {
        lblReportTitle.text = manager.getReportTitle()
        lblAmount.text = manager.getReportAmount()
        lblReportStartAndEndDate.text = manager.getReportDuration()
        lblStatus.text = manager.getReportStatus()
    }
}
