//
//  ExpenseDetailsToolBarEditEnabledStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - ExpenseDetailsToolBarEditEnabledStrategy
/***********************************/
struct ExpenseDetailsToolBarEditEnabledStrategy: ExpenseDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ExpenseDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnEdit = UIBarButtonItem(title: LocalizedString.edit, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnEdit.tag = ToolBarButtonTag.left.rawValue
        
        let btnClone = UIBarButtonItem(title: LocalizedString.clone, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnClone.tag = ToolBarButtonTag.middle.rawValue
        
        let btnMoreOptions = UIBarButtonItem(title: LocalizedString.moreOptions, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnMoreOptions.tag = ToolBarButtonTag.right.rawValue
        
        toolBar.items = [btnEdit, flexibleSpace, btnClone, flexibleSpace, btnMoreOptions]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forExpense expense: Expense, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ToolBarButtonTag.left.rawValue:
            log.debug("Edit tapped")
        case ToolBarButtonTag.middle.rawValue:
            log.debug("Clone tapped")
        case ToolBarButtonTag.right.rawValue:
            displayMoreOptions(forExpense: expense, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ExpenseDetailsToolBarEditEnabledStrategy {
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
    func displayMoreOptions(forExpense expense: Expense, onController controller: BaseViewController) {
        let actionSubmit = UIAlertAction(title: LocalizedString.submit, style: .default) { void in
            
        }
        
        let addExpense = UIAlertAction(title: LocalizedString.addExpense, style: .default) { void in
            // TODO - Make the add expense customised here.
            let addExpenseViewController = UIStoryboard(name: Constants.StoryboardIds.expenseStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Expense.addExpenseViewController) as! AddExpenseViewController
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