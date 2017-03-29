//
//  ExpenseDetailsToolBarStrategyWithoutUnlink.swift
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
struct ExpenseDetailsToolBarStrategyWithoutUnlink {
    let manager = ExpenseDetailsManager()
}
/***********************************/
// MARK: - ExpenseDetailsToolBarBaseStrategy
/***********************************/
extension ExpenseDetailsToolBarStrategyWithoutUnlink: ExpenseDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ExpenseDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // Add Comment
        let btnAddComment = UIBarButtonItem(title: LocalizedString.addComment, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnAddComment.tag = ToolBarButtonTag.middle.rawValue
        
        toolBar.items = [flexibleSpace, btnAddComment, flexibleSpace]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forExpense expense: Expense, onController controller: BaseViewController) {
        switch(barButton.tag) {
        case ToolBarButtonTag.left.rawValue:
            log.debug("Left toolbar button tapped")
        case ToolBarButtonTag.middle.rawValue:
            log.debug("Middle toolbar button tapped")
        case ToolBarButtonTag.right.rawValue:
            log.debug("Right toolbar button tapped")
        default:
            log.debug("Default")
        }
    }
}
