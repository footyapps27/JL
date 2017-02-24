//
//  AddExpense.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class AddExpenseViewController: BaseViewController {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let manager = AddExpenseManager()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }
}
