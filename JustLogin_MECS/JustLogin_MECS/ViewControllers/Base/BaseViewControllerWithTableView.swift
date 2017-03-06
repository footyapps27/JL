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
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    /***********************************/
    // MARK: - Birth & Death
    /***********************************/
    deinit {
        // Added, since we were getting an error when coming back to this screen. Bug with iOS framework?
        // http://stackoverflow.com/questions/32282401/attempting-to-load-the-view-of-a-view-controller-while-it-is-deallocating-uis
        
        searchController.view.removeFromSuperview()
    }
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
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
    
    
    func addSearchController(toTableView tableView: UITableView, withSearchResultsUpdater searchResultsUpdater: UISearchResultsUpdating) {
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
}
