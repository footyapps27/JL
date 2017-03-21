//
//  ReportDetailsToolBarApprovalListApprovedStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Properties
/***********************************/
struct ReportDetailsToolBarApprovalListApprovedStrategy {
    let manager = ReportDetailsManager()
}
/***********************************/
// MARK: - ReportDetailsToolBarBaseStrategy
/***********************************/
extension ReportDetailsToolBarApprovalListApprovedStrategy: ReportDetailsToolBarBaseStrategy {
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnReject = UIBarButtonItem(title: LocalizedString.reject, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnReject.tag = ReportDetailsToolBarButtonTag.left.rawValue
        
        let btnViewPDF = UIBarButtonItem(title: LocalizedString.viewPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewPDF.tag = ReportDetailsToolBarButtonTag.middle.rawValue
        
        let btnMoreOptions = UIBarButtonItem(title: LocalizedString.moreOptions, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnMoreOptions.tag = ReportDetailsToolBarButtonTag.right.rawValue
        
        toolBar.items = [btnReject, flexibleSpace, btnViewPDF, flexibleSpace, btnMoreOptions]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ReportDetailsToolBarButtonTag.left.rawValue:
            rejectReport(report, onController: controller)
        case ReportDetailsToolBarButtonTag.middle.rawValue:
            viewPDF(forReport: report, onController: controller)
        case ReportDetailsToolBarButtonTag.right.rawValue:
            displayMoreOptions(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportDetailsToolBarApprovalListApprovedStrategy {
    /**
     * Reject a report.
     */
    func rejectReport(_ report: Report, onController controller: BaseViewController) {
        ReportRejectionUtility.showReportRejectionAlert(report, onController: controller, manager: manager)
    }
    
    /**
     * Start the edit report flow.
     */
    func viewPDF(forReport report: Report, onController controller: BaseViewController) {
        
    }
    
    /**
     * Display the list of options for the user as an action sheet.
     */
    func displayMoreOptions(forReport report: Report, onController controller: BaseViewController) {
        let actionReject = UIAlertAction(title: LocalizedString.reject, style: .default) { void in
            self.rejectReport(report, onController: controller)
        }
        
        let recordReimbursement = UIAlertAction(title: LocalizedString.recordReimbursement, style: .default) { void in
            // TODO - Call the record reimbursement
        }
        
        let viewAsPDF = UIAlertAction(title: LocalizedString.viewPDF, style: .default) { void in
            self.viewPDF(forReport: report, onController: controller)
        }
        
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [actionReject, recordReimbursement, viewAsPDF ], onController: controller)
    }    
}
