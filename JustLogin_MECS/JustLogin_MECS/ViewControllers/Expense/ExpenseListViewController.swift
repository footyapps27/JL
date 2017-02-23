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
    
    let manager = ExpenseListManager()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        
        manager.fetchExpenses { [weak self] (response) in
            // TODO: - Add loading indicator
            guard let `self` = self else {
                log.error("self reference missing in closure.")
                return
            }
            
            switch(response) {
            case .success(_):
                self.tableView.isHidden = false
                self.tableView.reloadData()
            case .failure(_, let message):
                Utilities.showErrorAlert(withMessage: message, onController: self)
            }
        }
        
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
        // TODO: - Move to constants
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getExpenses().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ExpenseListTableViewCellIdentifier, for: indexPath) as? ExpenseListTableViewCell {
            
            let expense = manager.getExpenses()[indexPath.row]
            
            cell.lblExpenseName.text = manager.getCategoryName(forExpense: expense)
            cell.lblDateAndDescription.text = manager.getDateAndDescription(forExpense: expense)
            cell.lblAmount.text = String(expense.amount)
            cell.lblStatus.text = String(expense.status)
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
