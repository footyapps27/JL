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
    
    var expenseId: String?
    
    @IBOutlet weak var headerView: ExpenseDetailsHeaderView!
    
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    @IBOutlet weak var btnClone: UIBarButtonItem!
    
    @IBOutlet weak var btnMoreOptions: UIBarButtonItem!
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension ExpenseDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExpenseDetails()
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ExpenseDetailsViewController {
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cloneButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func moreOptionsButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ExpenseDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.expenseListTableViewCellIdentifier, for: indexPath) as! ExpenseListTableViewCell
//        
//        cell.lblExpenseName.text = manager.getCategoryName(forIndexPath: indexPath)
//        cell.lblDateAndDescription.text = manager.getDateAndDescription(forIndexPath: indexPath)
//        cell.lblAmount.text = manager.getFormattedAmount(forIndexPath: indexPath)
//        cell.lblStatus.text = manager.getExpenseStatus(forIndexPath: indexPath)
        
        // TODO: - Wire up the icons
        return UITableViewCell()
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ExpenseDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.getHeight()
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
        manager.fetchExpenseDetails(withExpenseId: expenseId!) { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.hideLoadingIndicator(enableUserInteraction: true)
            case .failure(_, _):
                // TODO: - Handle the empty table view screen.
                self.hideLoadingIndicator(enableUserInteraction: true)
            }
        }
    }
}
