//
//  BaseViewControllerWithTableView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 9/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class BaseViewControllerWithTableView: BaseViewController {
    
    let refreshControl = UIRefreshControl()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func addRefreshControl(toTableView tableView: UITableView, withAction action: Selector) {
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    
}
