//
//  ExpenseDetailsViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class ExpenseDetailsViewController: BaseViewController {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let manager = ExpenseDetailsManager()
    
    var expense: Expense?
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
