//
//  ReviewSelectExpenseViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 24/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Protocol
/***********************************/
protocol ReviewSelectExpenseViewControllerDelegate: class {
    func expensesSelected(_ expenses: [Expense])
}
/***********************************/
// MARK: - Properties
/***********************************/
class ReviewSelectExpenseViewController: BaseViewControllerWithTableView {
    
    let manager = ReviewSelectExpenseManager()
    
    weak var delegate: ReviewSelectExpenseViewControllerDelegate?
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReviewSelectExpenseViewController {
    func updateUI() {
        title = Constants.ViewControllerTitles.reviewSelectExpenses
        fetchExpenses()
    }
    
    func addBarButtonItems(forNormalState state: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedString.include, style: .plain, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReviewSelectExpenseViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchExpenses()
    }
    
    func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        dismissController()
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        // Call the delegate with the list of selected ids
        delegate?.expensesSelected(manager.getSelectedExpenses())
        dismissController()
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReviewSelectExpenseViewController {
    /**
     * Method to fetch currencies that will be displayed in the tableview.
     */
    func fetchExpenses() {
        
        if !refreshControl.isRefreshing {
            showLoadingIndicator(disableUserInteraction: false)
        }
        
        manager.fetchExpenses { [weak self] (response) in
            // TODO: - Add loading indicator
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            
            switch(response) {
            case .success(_):
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.setEditing(true, animated: false)
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
extension ReviewSelectExpenseViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getExpenses().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.expenseListTableViewCellIdentifier, for: indexPath) as! ExpenseListTableViewCell
        
        cell.lblExpenseName.text = manager.getCategoryName(forIndexPath: indexPath)
        cell.lblDateAndDescription.text = manager.getDateAndDescription(forIndexPath: indexPath)
        cell.lblAmount.text = manager.getFormattedAmount(forIndexPath: indexPath)
        cell.lblStatus.text = manager.getExpenseStatus(forIndexPath: indexPath)
        cell.imgAttachment.image = UIImage(named: manager.getAttachmentImage(forIndexPath: indexPath))
        cell.imgPolicyViolation.image = UIImage(named: manager.getPolicyViolationImage(forIndexPath: indexPath))
        
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReviewSelectExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            manager.addExpenseToSelectedExpenses(forIndexPath: indexPath)
        }
    }
}
