//
//  ReportDetailsToolBarApprovalListReimbursedStrategy.swift
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
struct ReportDetailsToolBarApprovalListReimbursedStrategy {
    let manager = ReportDetailsManager()
}
/***********************************/
// MARK: - ReportDetailsToolBarBaseStrategy
/***********************************/
extension ReportDetailsToolBarApprovalListReimbursedStrategy: ReportDetailsToolBarBaseStrategy {
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnViewPDF = UIBarButtonItem(title: LocalizedString.viewPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewPDF.tag = ToolBarButtonTag.left.rawValue
        
        let btnMoreOptions = UIBarButtonItem(title: LocalizedString.moreOptions, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnMoreOptions.tag = ToolBarButtonTag.right.rawValue
        
        toolBar.items = [flexibleSpace, btnViewPDF, flexibleSpace, btnMoreOptions, flexibleSpace]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ToolBarButtonTag.left.rawValue:
            viewPDF(forReport: report, onController: controller)
        case ToolBarButtonTag.right.rawValue:
            displayMoreOptions(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarApprovalListReimbursedStrategy {
    /**
     * Reject a report.
     */
    func undoReimbursement(_ report: Report, onController controller: BaseViewController) {
        var updatedReport = report
        updatedReport.status = ReportStatus.undoReimburse.rawValue
        ReportRejectionOrUndoReimburseUtility.showReportRejectionOrUndoReimburseAlert(updatedReport, onController: controller, manager: manager)
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
        let undoReimbursement = UIAlertAction(title: LocalizedString.undoReimbursement, style: .default) { void in
            self.undoReimbursement(report, onController: controller)
        }
        
        let viewAsPDF = UIAlertAction(title: LocalizedString.viewPDF, style: .default) { void in
            self.viewPDF(forReport: report, onController: controller)
        }
        
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [undoReimbursement, viewAsPDF ], onController: controller)
    }
}
