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
        btnSubmit.tag = ReportDetailsToolBarButtonTag.left.rawValue
        
        let btnEdit = UIBarButtonItem(title: LocalizedString.edit, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnEdit.tag = ReportDetailsToolBarButtonTag.middle.rawValue
        
        let btnMoreOptions = UIBarButtonItem(title: LocalizedString.moreOptions, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnMoreOptions.tag = ReportDetailsToolBarButtonTag.right.rawValue
        
        toolBar.items = [btnSubmit, flexibleSpace, btnEdit, flexibleSpace, btnMoreOptions]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ReportDetailsToolBarButtonTag.left.rawValue:
            navigateToApproversList(forReport: report, onController: controller)
        case ReportDetailsToolBarButtonTag.middle.rawValue:
            log.debug("Edit tapped")
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
extension ReportDetailsToolBarUnsubmittedStrategy {
    /**
     * Navigate to the approvers list for selecting the approver for this particular report.
     */
    func navigateToApproversList(forReport report: Report, onController controller: BaseViewController) {
        let approversListViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.approversListViewController) as! ApproversListViewController
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
            let addExpenseViewController = UIStoryboard(name: Constants.StoryboardIds.expenseStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.addExpenseViewController) as! AddExpenseViewController
            let navigationController = UINavigationController.init(rootViewController: addExpenseViewController)
            controller.present(navigationController, animated: true, completion: nil)
        }
        
        let includeExpense = UIAlertAction(title: LocalizedString.includeExpense, style: .default) { void in
            // TODO - Show the include expense screen
        }
        
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [actionSubmit, addExpense, includeExpense ], onController: controller)
    }
    
    /**
     * Start the edit report flow.
     */
    func navigateToEditReport(forReport report: Report, onController controller: BaseViewController) {
        
    }
}
