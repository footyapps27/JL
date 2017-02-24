//
//  ReportListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportListViewController: BaseViewControllerWithTableView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    @IBOutlet weak var tableView: UITableView!
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the search controller
        addSearchController(toTableView: tableView, withSearchResultsUpdater: self)
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

extension ReportListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Hardcoded data
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reportListTableViewCellIdentifier, for: indexPath) as? ReportListTableViewCell {
            cell.lblReportName.text = "Report Name"
            cell.lblDate.text = "04/07/2016 to 29/07/2016"
            cell.lblAmount.text = "$41.05"
            cell.lblStatus.text = "Approved"
            return cell
        }
        // TODO: - This has to be updated
        return UITableViewCell()
    }
}

extension ReportListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.reportListCellHeight)
    }
}

extension ReportListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
