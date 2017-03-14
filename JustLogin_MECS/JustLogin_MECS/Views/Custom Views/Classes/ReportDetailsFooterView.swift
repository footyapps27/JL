//
//  ReportDetailsFooterView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Properties
/***********************************/
class ReportDetailsFooterView: UIView {
    
    @IBOutlet weak var lblTotalReimbursableAmount: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    class func instanceFromNib() -> ReportDetailsFooterView {
        return UINib(nibName: String(describing: ReportDetailsFooterView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView as! ReportDetailsFooterView
    }
}
/***********************************/
// MARK: - UI update methods
/***********************************/
extension ReportDetailsFooterView {
    func updateView(withManager manager: ReportDetailsManager) {
        lblAmount.text = manager.getReportAmount()
    }
}
