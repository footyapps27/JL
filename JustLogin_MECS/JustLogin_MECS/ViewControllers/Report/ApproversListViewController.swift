//
//  ApproversListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 15/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Properties
/***********************************/
class ApproversListViewController: BaseViewControllerWithTableView {
    
    let manager = ApproversListManager()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension ApproversListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        
        addSearchController(toTableView: tableView, withSearchResultsUpdater: self)
        
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
        
        addBarButtonItems()
        
        fetchApprovers()
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ApproversListViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchApprovers()
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.indexPathForSelectedRow != nil {
            processReport()
        } else {
            Utilities.showErrorAlert(withMessage: "Please select approver for submitting the report to.", onController: self)
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ApproversListViewController {
    /**
     * Method to add bar button items.
     */
    func addBarButtonItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(rightBarButtonTapped(_:)))// TODO - Move to constants
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ApproversListViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func fetchApprovers() {
        
        if !refreshControl.isRefreshing {
            showLoadingIndicator(disableUserInteraction: false)
        }
        
        manager.fetchApprovers { [weak self] (response) in
            // TODO: - Add loading indicator
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            
            switch(response) {
            case .success(_):
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.refreshControl.isRefreshing ? self.refreshControl.endRefreshing() : self.hideLoadingIndicator(enableUserInteraction: true)
            case .failure(_, let message):
                // TODO: - Handle the empty table view screen.
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.refreshControl.isRefreshing ? self.refreshControl.endRefreshing() : self.hideLoadingIndicator(enableUserInteraction: true)
            }
        }
    }
    
    func processReport() {
        
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ApproversListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getApprovers().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.approversListTableViewCellIdentifier, for: indexPath) as! ApproversListTableViewCell
        // TODO - Map the image view here
        cell.lblName.text = manager.getMemberName(forIndexPath: indexPath)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ApproversListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        return indexPath
    }
}
/***********************************/
// MARK: - UISearchResultsUpdating
/***********************************/
extension ApproversListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
