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
        btnApprove.tag = ReportDetailsToolBarButtonTag.left.rawValue
        
        let btnReject = UIBarButtonItem(title: LocalizedString.reject, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnReject.tag = ReportDetailsToolBarButtonTag.middle.rawValue
        
        let btnViewPDF = UIBarButtonItem(title: LocalizedString.viewPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewPDF.tag = ReportDetailsToolBarButtonTag.right.rawValue
        
        toolBar.items = [btnApprove, flexibleSpace, btnReject, flexibleSpace, btnViewPDF]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
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
// MARK: - Actions
/***********************************/
extension ReportDetailsToolBarApprovalListSubmittedStrategy {
    /**
     * Approve a report.
     */
    func approveReport(_ report: Report, onController controller: BaseViewController) {
        var updatedReport = report
        updatedReport.status = ReportStatus.approved.rawValue
        // Call the service
        controller.showLoadingIndicator(disableUserInteraction: false)
        manager.processReport(report) { (response) in
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
        showReportRejectionAlert(report, onController: controller)
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
     * Method to display the rejection reason alert.
     */
    func showReportRejectionAlert(_ report: Report, onController controller: BaseViewController) {
        // TODO - Move to constants
        let alertController = UIAlertController(title: LocalizedString.reject, message: "Please specify an appropriate reason for rejection.", preferredStyle: .alert)
        
        let confirmAction = getRejectReportConfirmAction(report, onController: controller, alertController: alertController)
        
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
    }
    
    /**
     * The confirm action for the reject report alert.
     */
    func getRejectReportConfirmAction(_ report: Report, onController controller: BaseViewController, alertController: UIAlertController) -> UIAlertAction {
        return UIAlertAction(title: LocalizedString.confirm, style: .default, handler: {
            alert -> Void in
            // If the user has not input any rejection reason, we DO NOT proceed and show the same alert again.
            let reasonTextField = alertController.textFields![0] as UITextField
            if (reasonTextField.text?.isEmpty)! {
                alertController.dismiss(animated: true, completion: nil)
                // Show the alert again.
                _ = self.showReportRejectionAlert(report, onController: controller)
            } else {
                var updatedReport = report
                updatedReport.status = ReportStatus.rejected.rawValue
                updatedReport.rejectionReason = reasonTextField.text!
                self.callServiceForRejectingReport(updatedReport, onController: controller)
            }
        })
    }
    
    /**
     * Method to call the service for rejecting a report.
     * Once the report is rejected, the
     */
    func callServiceForRejectingReport(_ report: Report, onController controller: BaseViewController) {
        controller.showLoadingIndicator(disableUserInteraction: false)
        manager.processReport(report) { (response) in
            switch(response) {
            case .success(_):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showSuccessAlert(withMessage: "Report successfully rejected", onController: controller)
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportList), object: nil)
                _ = controller.navigationController?.popViewController(animated: true)
            case .failure(_, _):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                // TODO: - Need to kick the user out of this screen & send to the expense list.
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: controller)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
    
    func showAlertForSuccessfullyRejectedReport(onController controller: BaseViewController) {
        
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReportDetailsToolBarApprovalListSubmittedStrategy {
    /**
     * Method to call the service for updating the report status.
     */
    func callProcessReport(_ report: Report, onController controller: BaseViewController, successMessage: String) {
        controller.showLoadingIndicator(disableUserInteraction: false)
        manager.processReport(report) { (response) in
            switch(response) {
            case .success(_):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showSuccessAlert(withMessage: successMessage, onController: controller)
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
            case .failure(_, _):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                // TODO: - Need to kick the user out of this screen & send to the expense list.
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: controller)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
}
