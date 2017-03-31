//
//  ExpenseDetailsToolBarStrategyWithUnlink.swift
//  JustLogin_MECS
//
//  Created by Samrat on 29/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Properties
/***********************************/
struct ExpenseDetailsToolBarStrategyWithUnlink {
    let manager = ExpenseDetailsManager()
}
/***********************************/
// MARK: - ExpenseDetailsToolBarBaseStrategy
/***********************************/
extension ExpenseDetailsToolBarStrategyWithUnlink: ExpenseDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ExpenseDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // Add Comment
        let btnAddComment = UIBarButtonItem(title: LocalizedString.addComment, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnAddComment.tag = ToolBarButtonTag.left.rawValue
        
        // Remove
        let btnRemove = UIBarButtonItem(title: LocalizedString.remove, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnRemove.tag = ToolBarButtonTag.right.rawValue
        
        toolBar.items = [flexibleSpace, btnAddComment, flexibleSpace, btnRemove, flexibleSpace]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forExpense expense: Expense, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ToolBarButtonTag.left.rawValue:
            log.debug("Left toolbar button tapped")
        case ToolBarButtonTag.middle.rawValue:
            log.debug("Middle toolbar button tapped")
        case ToolBarButtonTag.right.rawValue:
            unlinkExpense(expense, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ExpenseDetailsToolBarStrategyWithUnlink {
    func unlinkExpense(_ expense: Expense, onController controller: BaseViewController) {
        manager.unlinkExpenseFromAttachedReport(expense) { (response) in
            controller.showLoadingIndicator(disableUserInteraction: false)
            switch(response) {
            case .success(_):
                // Navigate out of the expense details screen
                controller.hideLoadingIndicator(enableUserInteraction: true)
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
                _ = controller.navigationController?.popViewController(animated: true)
            case .failure(_, let message):
                controller.hideLoadingIndicator(enableUserInteraction: true)
                Utilities.showErrorAlert(withMessage: message, onController: controller)
            }
        }
    }
}
