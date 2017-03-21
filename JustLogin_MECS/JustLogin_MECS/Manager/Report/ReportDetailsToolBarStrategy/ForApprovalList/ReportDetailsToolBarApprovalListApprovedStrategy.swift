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
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarApprovalListApprovedStrategy {
    /**
     * Reject a report.
     */
    func rejectReport(_ report: Report, onController controller: BaseViewController) {
        // Show alert asking user the rejection reason
        let rejectionReason = showRejectionReasonAlert(report, onController: controller)
        
        var updatedReport = report
        updatedReport.status = ReportStatus.rejected.rawValue
        updatedReport.rejectionReason = rejectionReason
        callProcessReport(updatedReport, onController: controller)
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
    
    /**
     * Method to display the rejection reason alert.
     */
    func showRejectionReasonAlert(_ report: Report, onController controller: BaseViewController) -> String {
        
        var rejectionReason = Constants.General.emptyString
        // TODO - Move to constants
        let alertController = UIAlertController(title: LocalizedString.reject, message: "Please specify an appropriate reason for rejection.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: LocalizedString.confirm, style: .default, handler: {
            alert -> Void in
            let reasonTextField = alertController.textFields![0] as UITextField
            if (reasonTextField.text?.isEmpty)! {
                alertController.dismiss(animated: true, completion: nil)
                // Show the alert again.
                _ = self.showRejectionReasonAlert(report, onController: controller)
            } else {
                // Return the reason for the rejection
                rejectionReason = reasonTextField.text!
            }
        })
        
        let cancelAction = UIAlertAction(title: LocalizedString.cancel, style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.becomeFirstResponder()
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
        
        return rejectionReason
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReportDetailsToolBarApprovalListApprovedStrategy {
    /**
     * Method to call the service for updating the report status.
     */
    func callProcessReport(_ report: Report, onController controller: BaseViewController) {
        controller.showLoadingIndicator(disableUserInteraction: false)
        manager.processReport(report) { (response) in
            switch(response) {
            case .success(_):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showSuccessAlert(withMessage: "Report successfully approved.", onController: controller)
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
            case .failure(_, _):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                // TODO: - Need to kick the user out of this screen & send to the expense list.
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: controller)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
}
