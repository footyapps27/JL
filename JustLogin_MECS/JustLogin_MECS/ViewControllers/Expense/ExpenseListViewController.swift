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
    
    let manager = ExpenseListManager()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        // Attach the refresh control
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
        
        addBarButtonItems(forNormalState: true)
        
        fetchExpenses()
        
        // Add the search controller
        addSearchController(toTableView: tableView, withSearchResultsUpdater: self)
    }
    
    /***********************************/
    // MARK: - Actions
    /***********************************/
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchExpenses()
    }
    
    @IBAction func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        if !tableView.isEditing {
            manager.refreshSelectedIndices()
        }
        addBarButtonItems(forNormalState: tableView.isEditing)
        self.tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @IBAction func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            if manager.selectedIndices.count > 0 {
                showActionsForMultipleExpenses()
            }
        } else {
            // TODO: - Start the add expense here
        }
    }
    /***********************************/
    // MARK: - Helpers
    /***********************************/
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        //        filteredCandies = candies.filter { candy in
        //            return candy.name.lowercaseString.containsString(searchText.lowercaseString)
        //        }
        
        tableView.reloadData()
    }
    
    /**
     * Method to add bar button items (left & right) depending on the state of the tableview. (editing or normal).
     */
    func addBarButtonItems(forNormalState state: Bool) {
        let leftSystemItem = state ? UIBarButtonSystemItem.edit : UIBarButtonSystemItem.cancel
        let rightSystemItem = state ? UIBarButtonSystemItem.add : UIBarButtonSystemItem.done
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: leftSystemItem, target: self, action: #selector(leftBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: rightSystemItem, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func fetchExpenses() {
        manager.fetchExpenses { [weak self] (response) in
            // TODO: - Add loading indicator
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            
            switch(response) {
            case .success(_):
                self.hideLoadingIndicators()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                
            case .failure(_, let message):
                // TODO: - Handle the empty table view screen.
                self.hideLoadingIndicators()
                Utilities.showErrorAlert(withMessage: message, onController: self)
            }
        }
    }
    
    /**
     * Method to display the actions for multiple expenses.
     */
    func showActionsForMultipleExpenses() {
        // TODO - Move to string constants
        let actionAddToReport = UIAlertAction(title:"Add to report", style: .default) { void in
            // TODO: - Show the list of reports
        }
        
        let actionDeleteExpenses = UIAlertAction(title:"Delete expenses", style: .default) { [weak self] void in
            
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            
            let ids = self.manager.getSelectedExpenseIds()
            self.manager.deleteExpenses(ids, completionHandler: { (response) in
                switch(response) {
                case .success(_):
                    self.manager.updateExpensesAfterDelete()
                    self.tableView.reloadData()
                case .failure(_ , let message):
                    self.hideLoadingIndicators()
                    Utilities.showErrorAlert(withMessage: message, onController: self)
                }
            })
        }
        
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [actionAddToReport, actionDeleteExpenses], onController: self)
    }
    
    /**
     * Method to hide loading indicators.
     */
    func hideLoadingIndicators() {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
}

/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ExpenseListViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.Defaults.numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getExpenses().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.expenseListTableViewCellIdentifier, for: indexPath) as! ExpenseListTableViewCell
        
        cell.lblExpenseName.text = manager.getCategoryName(forIndexPath: indexPath)
        cell.lblDateAndDescription.text = manager.getDateAndDescription(forIndexPath: indexPath)
        cell.lblAmount.text = manager.getFormattedAmount(forIndexPath: indexPath)
        cell.lblStatus.text = manager.getExpenseStatus(forIndexPath: indexPath)
        
        // TODO: - Wire up the icons
        
        return cell
    }
}

/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ExpenseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.expenseListCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            manager.addExpenseToSelectedExpenses(forIndexPath: indexPath)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: - Navigate to the detail page
    }
}

extension ExpenseListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
