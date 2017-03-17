//
//  ReportDetailsTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportDetailsTableViewCell: BaseCustomTableViewCell {
    
    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet weak var parentStackViewHeight: NSLayoutConstraint!
}
/***********************************/
// MARK: - UI update methods
/***********************************/
extension ReportDetailsTableViewCell {
    func updateView(withFields fields: [String:String]) {
        
        for dict in fields {
            let view = Utilities.getDynamicView(withFieldName: dict.key, andFieldValue: dict.value)
            parentStackView.addArrangedSubview(view)
            parentStackViewHeight.constant += CGFloat(50)
        }
        //setNeedsLayout()
    }
    
    /**
     * The height of the view after the stack view has been dynamically populated.
     */
    func getHeight() -> CGFloat {
        return parentStackViewHeight.constant
    }
}
