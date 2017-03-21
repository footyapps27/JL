//
//  ReportDetailsToolBarApprovedAndReimbursedStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - ReportDetailsToolBarBaseStrategy
/***********************************/
struct ReportDetailsToolBarApprovedAndReimbursedStrategy: ReportDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnViewPDF = UIBarButtonItem(title: LocalizedString.viewPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewPDF.tag = ReportDetailsToolBarButtonTag.middle.rawValue
        
        toolBar.items = [flexibleSpace, btnViewPDF, flexibleSpace]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ReportDetailsToolBarButtonTag.middle.rawValue:
            viewAsPDF(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarApprovedAndReimbursedStrategy {
    /**
     * View the report as PDF.
     */
    func viewAsPDF(forReport report: Report, onController controller: BaseViewController) {
        // TODO - Part of phase 2.
    }
}
