//
//  ReportDetailsToolBarApprovalListSubmittedStrategy.swift
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
struct ReportDetailsToolBarApprovalListSubmittedStrategy: ReportDetailsToolBarBaseStrategy {
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnApprove = UIBarButtonItem(title: LocalizedString.approve, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnApprove.tag = ReportDetailsToolBarButtonTag.left.rawValue
        
        let btnReject = UIBarButtonItem(title: LocalizedString.reject, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnReject.tag = ReportDetailsToolBarButtonTag.middle.rawValue
        
        let btnViewPDF = UIBarButtonItem(title: LocalizedString.viewPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewPDF.tag = ReportDetailsToolBarButtonTag.right.rawValue
        
        toolBar.items = [btnApprove, flexibleSpace, btnReject, flexibleSpace, btnViewPDF]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: ReportDetailsViewController) {
        switch(barButton.tag) {
        case ReportDetailsToolBarButtonTag.left.rawValue:
            approveReport(report, onController: controller)
        case ReportDetailsToolBarButtonTag.middle.rawValue:
            rejectReport(report, onController: controller)
        case ReportDetailsToolBarButtonTag.right.rawValue:
            viewPDF(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarApprovalListSubmittedStrategy {
    /**
     * Approve a report.
     */
    func approveReport(_ report: Report, onController controller: ReportDetailsViewController) {
        // TODO - Approve report
        // TODO - After successful report, show alerts & update the details & list
    }
    
    /**
     * Reject a report.
     */
    func rejectReport(_ report: Report, onController controller: ReportDetailsViewController) {
        // TODO - Reject report
        // TODO - After successful report, show alerts & update the details & list
    }
    
    /**
     * Start the edit report flow.
     */
    func viewPDF(forReport report: Report, onController controller: ReportDetailsViewController) {
        
    }
}
