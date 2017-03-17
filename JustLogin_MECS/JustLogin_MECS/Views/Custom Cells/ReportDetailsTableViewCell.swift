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
    
    @IBOutlet weak var lblFieldName: UILabel!
    
    @IBOutlet weak var lblFieldValue: UILabel!
}
/***********************************/
// MARK: - UI update methods
/***********************************/
extension ReportDetailsTableViewCell {
    func updateView(withFieldName fieldName: String, fieldValue: String) {
        lblFieldName.text = fieldName
        lblFieldValue.text = fieldValue
    }
    
    /**
     * The height of the view after the stack view has been dynamically populated.
     */
    func getHeight() -> CGFloat {
        return 62
    }
}
