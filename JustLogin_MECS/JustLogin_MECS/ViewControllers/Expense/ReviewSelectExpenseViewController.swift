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
protocol ReviewSelectExpenseDelegate: class {
    func expensesSelected(_ expenses: [Expense])
}
/***********************************/
// MARK: - Properties
/***********************************/
class ReviewSelectExpenseViewController: BaseViewControllerWithTableView {
    
    let manager = ReviewSelectExpenseManager()
    
    var report: Report?
    
    weak var delegate: ReviewSelectExpenseDelegate?
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.report = report!
        
        updateUI()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReviewSelectExpenseViewController {
    func updateUI() {
        title = Constants.ViewControllerTitles.reviewSelectExpenses
        tableView.allowsMultipleSelectionDuringEditing = true
        addBarButtonItems()
        fetchExpenses()
    }
    
    func addBarButtonItems() {
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
    
    func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        dismissController()
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.indexPathsForSelectedRows?.count != 0 {
            // Call the delegate with the list of selected ids
            callAttachSelectedExpensesToReport()
        } else {
            // TODO - Add to messages
            Utilities.showErrorAlert(withMessage: "Please select atleast one expense to include.", onController: self)
        }
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
        showLoadingIndicator(disableUserInteraction: false)
        
        manager.fetchExpenses { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            
            switch(response) {
            case .success(_):
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.setEditing(true, animated: false)
                self.hideLoadingIndicator(enableUserInteraction: true)
            case .failure(_, let message):
                // TODO: - Handle the empty table view screen.
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.hideLoadingIndicator(enableUserInteraction: true)
            }
        }
    }
    
    func callAttachSelectedExpensesToReport() {
        showLoadingIndicator(disableUserInteraction: false)
        manager.attachSelectedExpensesToReport(fromSelectedIndexPaths: tableView.indexPathsForSelectedRows!) { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            
            switch(response) {
            case .success(_):
                let selectedExpenses = self.manager.getSelectedExpenses(fromSelectedIndexPaths: self.tableView.indexPathsForSelectedRows!)
                self.delegate?.expensesSelected(selectedExpenses)
                self.dismissController()
                self.hideLoadingIndicator(enableUserInteraction: true)
            case .failure(_, let message):
                // TODO: - Handle the empty table view screen.
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.hideLoadingIndicator(enableUserInteraction: true)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.expenseListCellHeight)
    }
}
