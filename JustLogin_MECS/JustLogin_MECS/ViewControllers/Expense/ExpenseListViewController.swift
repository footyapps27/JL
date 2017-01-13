//
//  ExpenseListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 9/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ExpenseListViewController: BaseViewControllerWithTableView {
    
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

extension ExpenseListViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.backgroundColor = UIColor.blue
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Hardcoded data
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ExpenseListTableViewCellIdentifier, for: indexPath) as? ExpenseListTableViewCell {
            cell.lblExpenseName.text = "Air Travel Expense"
            cell.lblDateAndDescription.text = "04/07/2016 | Starbucks"
            cell.lblAmount.text = "$121.75"
            cell.lblStatus.text = "Submitted"
            return cell
        }
        // TODO: - This has to be updated
        return UITableViewCell()
    }
}

extension ExpenseListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.ExpenseListCellHeight)
    }

}

extension ExpenseListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
