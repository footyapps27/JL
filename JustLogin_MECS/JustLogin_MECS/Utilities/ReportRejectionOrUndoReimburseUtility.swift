//
//  ReportRejectionUtility.swift
//  JustLogin_MECS
//
//  Created by Samrat on 21/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Public Mthods
/***********************************/
struct ReportRejectionOrUndoReimburseUtility {
    /**
     * Method to display the rejection reason alert.
     * It is important that the status of the report is set to the desired value before sending to this utility.
     */
    static func showReportRejectionOrUndoReimburseAlert(_ report: Report, onController controller: BaseViewController, manager: ReportDetailsManager) {
        
        let titleAndMessage = self.getAlertMessage(forReport: report)
        
        let alertController = UIAlertController(title: titleAndMessage.title, message: titleAndMessage.message, preferredStyle: .alert)
        
        let confirmAction = self.getRejectReportOrUndoReimburseConfirmAction(report, onController: controller, alertController: alertController, manager: manager)
        
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
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportRejectionOrUndoReimburseUtility {
    /**
     * The confirm action for the reject report alert.
     */
    fileprivate static func getRejectReportOrUndoReimburseConfirmAction(_ report: Report, onController controller: BaseViewController, alertController: UIAlertController, manager: ReportDetailsManager) -> UIAlertAction {
        return UIAlertAction(title: LocalizedString.confirm, style: .default, handler: {
            alert -> Void in
            // If the user has not input any rejection reason, we DO NOT proceed and show the same alert again.
            let reasonTextField = alertController.textFields![0] as UITextField
            if (reasonTextField.text?.isEmpty)! {
                alertController.dismiss(animated: true, completion: nil)
                // Show the alert again.
                _ = self.showReportRejectionOrUndoReimburseAlert(report, onController: controller, manager: manager)
            } else {
                var updatedReport = report
                updatedReport.rejectionReason = reasonTextField.text!
                self.callServiceForRejectingOrUndoReimburseReport(updatedReport, onController: controller, manager: manager)
            }
        })
    }
    
    fileprivate static func performActionOnSuccessReponse(forReport report: Report, onController controller: BaseViewController) {
        NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshApprovalList), object: nil)
        
        // Based on the status, we take more specific actions
        if report.status == ReportStatus.rejected.rawValue {
            self.showAlertForSuccessfullyRejectedReport(onController: controller)
        } else {
            NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
        }
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReportRejectionOrUndoReimburseUtility {
    /**
     * Method to call the service for rejecting a report.
     */
    fileprivate static func callServiceForRejectingOrUndoReimburseReport(_ report: Report, onController controller: BaseViewController, manager: ReportDetailsManager) {
        controller.showLoadingIndicator(disableUserInteraction: false)
        
        let payload = self.getPayloadForProcessReport(report)
        manager.processReport(withPayload: payload) { (response) in
            switch(response) {
            case .success(_):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                performActionOnSuccessReponse(forReport: report, onController: controller)
            case .failure(_, _):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                // TODO: - Need to kick the user out of this screen & send to the expense list.
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: controller)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportRejectionOrUndoReimburseUtility {
    /**
     * Show the alert when a report has been successfully rejected.
     * The user will be moved out of the details screen.
     */
    fileprivate static func showAlertForSuccessfullyRejectedReport(onController controller: BaseViewController) {
        // TODO: - Add to the text file.
        let alert = UIAlertController(title: "Success", message: "Report successfully rejected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // Pop out from the controller after the user taps ok.
            alert.dismiss(animated: true, completion:nil)
            _ = controller.navigationController?.popViewController(animated: true)
        })
        controller.present(alert, animated: true)
    }
    
    /**
     * Get the alert title & message based on the report status. 
     */
    fileprivate static func getAlertMessage(forReport report: Report) -> (title: String, message: String) {
        if report.status == ReportStatus.rejected.rawValue {
            return (LocalizedString.reject ,"Please specify an appropriate reason for rejection.")
        }
        return (LocalizedString.undoReimbursement ,"Please specify an appropriate reason for cancelling the reimbursement.")
    }
    
    /**
     * Get the payload for processing a report.
     */
    fileprivate static func getPayloadForProcessReport(_ report: Report) -> [String : Any] {
        return [
            Constants.RequestParameters.Report.reportId : report.id,
            Constants.RequestParameters.Report.statusType : report.status,
            Constants.RequestParameters.Report.reason : report.rejectionReason
        ]
    }
}
