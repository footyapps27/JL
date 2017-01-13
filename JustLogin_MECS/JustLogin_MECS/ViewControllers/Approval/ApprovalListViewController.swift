//
//  ApprovalListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ApprovalListViewController: BaseViewControllerWithTableView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    /***********************************/
    // MARK: - Actions
    /***********************************/
    
    
    /***********************************/
    // MARK: - Helpers
    /***********************************/
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        //        filteredCandies = candies.filter { candy in
        //            return candy.name.lowercaseString.containsString(searchText.lowercaseString)
        //        }
        
        tableView.reloadData()
    }
    
}

extension ApprovalListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Hardcoded data
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ApprovalListTableViewCellIdentifier, for: indexPath) as? ApprovalListTableViewCell {
            cell.lblReportName.text = "Office party"
            cell.lblEmployeeName.text = "John Doe"
            cell.lblAmount.text = "$98.55"
            cell.lblStatus.text = "Overdue by 1 day"
            return cell
        }
        // TODO: - This has to be updated
        return UITableViewCell()
    }
}

extension ApprovalListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.ApprovalListCellHeight)
    }
}

extension ApprovalListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
