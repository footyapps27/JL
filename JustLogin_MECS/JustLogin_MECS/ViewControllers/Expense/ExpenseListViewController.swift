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
    
    let manager = ExpenseListManager()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        addSearchController(toTableView: tableView, withSearchResultsUpdater: self)
        
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
        
        addBarButtonItems(forNormalState: true)
        
        fetchExpenses()
    }
    
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ExpenseListViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchExpenses()
    }
    
    func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        if !tableView.isEditing {
            manager.refreshSelectedIndices()
        }
        addBarButtonItems(forNormalState: tableView.isEditing)
        self.tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            if manager.selectedIndices.count > 0 {
                showActionsForMultipleExpenses()
            }
        } else {
            navigateToAddExpense()
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ExpenseListViewController {
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
            
            self.showLoadingIndicator(disableUserInteraction: false)
            self.manager.deleteSelectedExpenses(completionHandler: { (response) in
                self.hideLoadingIndicator(enableUserInteraction: true)
                switch(response) {
                case .success(_):
                    self.tableView.reloadData()
                case .failure(_ , let message):
                    Utilities.showErrorAlert(withMessage: message, onController: self)
                }
            })
        }
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [actionAddToReport, actionDeleteExpenses], onController: self)
    }
    
    func navigateToAddExpense() {
        let addExpenseViewController = UIStoryboard(name: Constants.StoryboardIds.expenseStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.addExpenseViewController) as! BaseViewController
        Utilities.pushControllerAndHideTabbar(fromController:self, toController: addExpenseViewController)
    }
    
    func navigateToExpenseDetails(forExpense expense: Expense) {
        let expenseDetailsViewController = UIStoryboard(name: Constants.StoryboardIds.expenseStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.expenseDetailsViewController) as! ExpenseDetailsViewController
        expenseDetailsViewController.expenseId = expense.id
        Utilities.pushControllerAndHideTabbar(fromController:self, toController: expenseDetailsViewController)
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ExpenseListViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func fetchExpenses() {
        
        if !refreshControl.isRefreshing {
            showLoadingIndicator(disableUserInteraction: false)
        }
        
        manager.fetchExpenses { [weak self] (response) in
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
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ExpenseListViewController: UITableViewDataSource {
    
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
        navigateToExpenseDetails(forExpense: manager.getExpenses()[indexPath.row])
    }
}
/***********************************/
// MARK: - UISearchResultsUpdating
/***********************************/
extension ExpenseListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: - Implementation missing
    }
}
