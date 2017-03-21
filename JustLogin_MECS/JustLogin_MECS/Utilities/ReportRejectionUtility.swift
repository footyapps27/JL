//
//  ReportRejectionUtility.swift
//  JustLogin_MECS
//
//  Created by Samrat on 21/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

struct ReportRejectionUtility {
    /**
     * Method to display the rejection reason alert.
     */
    static func showReportRejectionAlert(_ report: Report, onController controller: BaseViewController, manager: ReportDetailsManager) {
        // TODO - Move to constants
        let alertController = UIAlertController(title: LocalizedString.reject, message: "Please specify an appropriate reason for rejection.", preferredStyle: .alert)
        
        let confirmAction = self.getRejectReportConfirmAction(report, onController: controller, alertController: alertController, manager: manager)
        
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
    static func getRejectReportConfirmAction(_ report: Report, onController controller: BaseViewController, alertController: UIAlertController, manager: ReportDetailsManager) -> UIAlertAction {
        return UIAlertAction(title: LocalizedString.confirm, style: .default, handler: {
            alert -> Void in
            // If the user has not input any rejection reason, we DO NOT proceed and show the same alert again.
            let reasonTextField = alertController.textFields![0] as UITextField
            if (reasonTextField.text?.isEmpty)! {
                alertController.dismiss(animated: true, completion: nil)
                // Show the alert again.
                _ = self.showReportRejectionAlert(report, onController: controller, manager: manager)
            } else {
                var updatedReport = report
                updatedReport.status = ReportStatus.rejected.rawValue
                updatedReport.rejectionReason = reasonTextField.text!
                self.callServiceForRejectingReport(updatedReport, onController: controller, manager: manager)
            }
        })
    }
    
    /**
     * Method to call the service for rejecting a report.
     */
    static func callServiceForRejectingReport(_ report: Report, onController controller: BaseViewController, manager: ReportDetailsManager) {
        controller.showLoadingIndicator(disableUserInteraction: false)
        manager.processReport(report) { (response) in
            switch(response) {
            case .success(_):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshApprovalList), object: nil)
                self.showAlertForSuccessfullyRejectedReport(onController: controller)
            case .failure(_, _):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                // TODO: - Need to kick the user out of this screen & send to the expense list.
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: controller)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
    
    /**
     * Show the alert when a report has been successfully rejected.
     * The user will be moved out of the details screen.
     */
    static func showAlertForSuccessfullyRejectedReport(onController controller: BaseViewController) {
        // TODO: - Add to the text file.
        let alert = UIAlertController(title: "Success", message: "Report successfully rejected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // Pop out from the controller after the user taps ok.
            alert.dismiss(animated: true, completion:nil)
            _ = controller.navigationController?.popViewController(animated: true)
        })
        controller.present(alert, animated: true)
    }
}
