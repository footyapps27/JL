//
//  ReportDetailsToolBarUnsubmittedStrategy.swift
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
struct ReportDetailsToolBarUnsubmittedStrategy: ReportDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnSubmit = UIBarButtonItem(title: LocalizedString.submit, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnSubmit.tag = ToolBarButtonTag.left.rawValue
        
        let btnEdit = UIBarButtonItem(title: LocalizedString.edit, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnEdit.tag = ToolBarButtonTag.middle.rawValue
        
        let btnMoreOptions = UIBarButtonItem(title: LocalizedString.moreOptions, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnMoreOptions.tag = ToolBarButtonTag.right.rawValue
        
        toolBar.items = [btnSubmit, flexibleSpace, btnEdit, flexibleSpace, btnMoreOptions]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ToolBarButtonTag.left.rawValue:
            navigateToApproversList(forReport: report, onController: controller)
        case ToolBarButtonTag.middle.rawValue:
            navigateToEditReport(forReport: report, onController: controller)
        case ToolBarButtonTag.right.rawValue:
            displayMoreOptions(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportDetailsToolBarUnsubmittedStrategy {
    /**
     * Navigate to the approvers list for selecting the approver for this particular report.
     */
    func navigateToApproversList(forReport report: Report, onController controller: BaseViewController) {
        let approversListViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Approval.approversListViewController) as! ApproversListViewController
        approversListViewController.report = report
        approversListViewController.delegate = controller as? ApproversListDelegate
        Utilities.pushControllerAndHideTabbarForChildAndParent(fromController: controller, toController: approversListViewController)
    }
    
    /**
     * Display the list of options for the user as an action sheet.
     */
    func displayMoreOptions(forReport report: Report, onController controller: BaseViewController) {
        let actionSubmit = UIAlertAction(title: LocalizedString.submit, style: .default) { void in
            self.navigateToApproversList(forReport: report, onController: controller)
        }
        
        let addExpense = UIAlertAction(title: LocalizedString.addExpense, style: .default) { void in
            self.navigateToAddEditExpenseController(fromController: controller)
        }
        
        let includeExpense = UIAlertAction(title: LocalizedString.includeExpense, style: .default) { void in
            self.navigateToReviewSelectExpenseController(forReport: report, fromController: controller)
        }
        
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [actionSubmit, addExpense, includeExpense ], onController: controller)
    }
    
    /**
     * Start the edit report flow.
     */
    func navigateToEditReport(forReport report: Report, onController controller: BaseViewController) {
        let addEditReportViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Report.addEditReportViewController) as! AddEditReportViewController
        addEditReportViewController.report = report
        addEditReportViewController.delegate = controller as? AddEditReportDelegate
        Utilities.pushControllerAndHideTabbarForChildAndParent(fromController: controller, toController: addEditReportViewController)
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarUnsubmittedStrategy {
    /**
     * Method to navigate to the AddEditExpenseViewController.
     */
    func navigateToAddEditExpenseController(fromController controller: BaseViewController) {
        // TODO - Make the add expense customised here.
        let addEditExpenseViewController = UIStoryboard(name: Constants.StoryboardIds.expenseStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Expense.addEditExpenseViewController) as! AddEditExpenseViewController
        let navigationController = UINavigationController.init(rootViewController: addEditExpenseViewController)
        controller.present(navigationController, animated: true, completion: nil)
    }
    /**
     * Method to navigate to the ReviewSelectExpenseController.
     */
    func navigateToReviewSelectExpenseController(forReport report: Report, fromController controller: BaseViewController) {
        let reviewSelectExpenseViewController = UIStoryboard(name: Constants.StoryboardIds.expenseStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Expense.reviewSelectExpenseViewController) as! ReviewSelectExpenseViewController
        reviewSelectExpenseViewController.report = report
        reviewSelectExpenseViewController.delegate = controller as? ReviewSelectExpenseDelegate
        let navigationController = UINavigationController.init(rootViewController: reviewSelectExpenseViewController)
        controller.present(navigationController, animated: true, completion: nil)
    }
}
