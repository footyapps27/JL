//
//  ExpenseDetailsViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
class ExpenseDetailsViewController: BaseViewControllerWithTableView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let manager = ExpenseDetailsManager()
    
    var expense: Expense?
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    var headerView: ExpenseDetailsHeaderView?
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension ExpenseDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set this, since we need to set the headers. 
        // Will improve performance
        manager.expense = expense!
        
        fetchExpenseDetails()
        tableView.allowsSelection = false
        
        headerView = ExpenseDetailsHeaderView.instanceFromNib()
        headerView?.delegate = self
        
        updateTableHeaderView()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ExpenseDetailsViewController {
    func updateUIAfterSuccessfulResponse() {
        updateTableHeaderView()
        self.tableView.reloadData()
        manager.updateToolBar(toolbar, delegate: self)
    }
    
    func updateTableHeaderView() {
        headerView!.updateView(withManager: manager)
        headerView!.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: headerView!.getHeight())
        tableView.tableHeaderView = headerView
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ExpenseDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getAuditHistories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.auditHistoryTableViewCellIdentifier, for: indexPath) as! AuditHistoryTableViewCell
        
        cell.lblDescription.text = manager.getAuditHistoryDescription(forIndexPath: indexPath)
        cell.lblUserAndDate.text = manager.getAuditHistoryDetails(forIndexPath: indexPath)
        
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ExpenseDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.expenseAuditHistoryCellHeight)
    }
}
/***********************************/
// MARK: - ExpenseDetailsHeaderViewDelegate
/***********************************/
extension ExpenseDetailsViewController: ExpenseDetailsHeaderViewDelegate {
    func attachmentButtonTapped() {
        // TODO: - Handle the action related stuff here.
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ExpenseDetailsViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func fetchExpenseDetails() {
        showLoadingIndicator(disableUserInteraction: false)
        manager.fetchExpenseDetails(withExpenseId: expense!.id) { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.updateUIAfterSuccessfulResponse()
                self.hideLoadingIndicator(enableUserInteraction: true)
            case .failure(_, _):
                self.hideLoadingIndicator(enableUserInteraction: true)
                // TODO: - Need to kick the user out of this screen & send to the expense list.
                Utilities.showErrorAlert(withMessage: "Something went wrong. Please try again.", onController: self)// TODO: - Hard coded message. Move to constants or use the server error.
            }
        }
    }
}
/***********************************/
// MARK: - ExpenseDetailsToolBarActionDelegate
/***********************************/
extension ExpenseDetailsViewController: ExpenseDetailsToolBarActionDelegate {
    func barButtonItemTapped(_ sender: UIBarButtonItem) {
        manager.performActionForBarButtonItem(sender, onController: self)
    }
}
