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
// MARK: - Properties
/***********************************/
struct ReportDetailsToolBarApprovalListSubmittedStrategy {
    let manager = ReportDetailsManager()
}
/***********************************/
// MARK: - ReportDetailsToolBarBaseStrategy
/***********************************/
extension ReportDetailsToolBarApprovalListSubmittedStrategy: ReportDetailsToolBarBaseStrategy {
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnApprove = UIBarButtonItem(title: LocalizedString.approve, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnApprove.tag = ToolBarButtonTag.left.rawValue
        
        let btnReject = UIBarButtonItem(title: LocalizedString.reject, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnReject.tag = ToolBarButtonTag.middle.rawValue
        
        let btnViewPDF = UIBarButtonItem(title: LocalizedString.viewPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewPDF.tag = ToolBarButtonTag.right.rawValue
        
        toolBar.items = [btnApprove, flexibleSpace, btnReject, flexibleSpace, btnViewPDF]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ToolBarButtonTag.left.rawValue:
            approveReport(report, onController: controller)
        case ToolBarButtonTag.middle.rawValue:
            rejectReport(report, onController: controller)
        case ToolBarButtonTag.right.rawValue:
            viewPDF(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportDetailsToolBarApprovalListSubmittedStrategy {
    /**
     * Approve a report.
     */
    func approveReport(_ report: Report, onController controller: BaseViewController) {
        var updatedReport = report
        updatedReport.status = ReportStatus.approved.rawValue
        // Payload
        let payload = getPayloadForProcessReport(updatedReport)
        // Call the service
        controller.showLoadingIndicator(disableUserInteraction: false)
        manager.processReport(withPayload: payload) { (response) in
            switch(response) {
            case .success(_):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showSuccessAlert(withMessage: "Report successfully approved.", onController: controller)
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
            case .failure(_, _):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: controller)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
    
    /**
     * Reject a report.
     */
    func rejectReport(_ report: Report, onController controller: BaseViewController) {
        var updatedReport = report
        updatedReport.status = ReportStatus.rejected.rawValue
        ReportRejectionOrUndoReimburseUtility.showReportRejectionOrUndoReimburseAlert(updatedReport, onController: controller, manager: manager)
    }
    
    /**
     * Start the edit report flow.
     */
    func viewPDF(forReport report: Report, onController controller: BaseViewController) {
        
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarApprovalListSubmittedStrategy {
    /**
     * Get the formatted payload for the approval action.
     */
    func getPayloadForProcessReport(_ report: Report) -> [String : Any] {
        return [
            Constants.RequestParameters.Report.reportId : report.id,
            Constants.RequestParameters.Report.statusType : report.status
        ]
    }
}
