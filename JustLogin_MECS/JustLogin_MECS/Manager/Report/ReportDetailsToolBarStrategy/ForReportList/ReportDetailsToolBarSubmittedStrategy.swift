//
//  ReportDetailsToolBarSubmittedStrategy.swift
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
struct ReportDetailsToolBarSubmittedStrategy {
    let manager = ReportDetailsManager()
}
/***********************************/
// MARK: - ReportDetailsToolBarBaseStrategy
/***********************************/
extension ReportDetailsToolBarSubmittedStrategy: ReportDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnRecall = UIBarButtonItem(title: LocalizedString.recall, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnRecall.tag = ToolBarButtonTag.left.rawValue
        
        let btnViewPDF = UIBarButtonItem(title: LocalizedString.viewPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewPDF.tag = ToolBarButtonTag.right.rawValue
        
        toolBar.items = [flexibleSpace, btnRecall, flexibleSpace, btnViewPDF, flexibleSpace]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ToolBarButtonTag.left.rawValue:
            recallReport(report, onController: controller)
        case ToolBarButtonTag.right.rawValue:
            viewAsPDF(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportDetailsToolBarSubmittedStrategy {
    /**
     * Recall report.
     */
    func recallReport(_ report: Report, onController controller: BaseViewController) {
        // Update the report
        var updatedReport = report
        updatedReport.status = ReportStatus.recalled.rawValue
        // Now get the payload from the report
        let payload = getPayloadForProcessReport(updatedReport)
        // Call the service
        controller.showLoadingIndicator(disableUserInteraction: false)
        manager.processReport(withPayload: payload) { (response) in
            switch(response) {
            case .success(_):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showSuccessAlert(withMessage: "Report successfully recalled.", onController: controller)
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
            case .failure(_, _):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: controller)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
    
    /**
     * Display the list of options for the user as an action sheet.
     */
    func viewAsPDF(forReport report: Report, onController controller: BaseViewController) {
        // TODO - Part of phase 2.
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarSubmittedStrategy {
    func getPayloadForProcessReport(_ report: Report) -> [String : Any] {
        return [
            Constants.RequestParameters.Report.reportId : report.id,
            Constants.RequestParameters.Report.statusType : report.status
        ]
    }
}
