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
    
    @IBOutlet weak var toolbar: UIToolbar!
    
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
        headerView.delegate = self
        fetchExpenseDetails()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ExpenseDetailsViewController {
    func updateUIAfterSuccessfulResponse() {
        headerView.updateView(withManager: manager)
        self.tableView.reloadData()
        updateToolbarItems()
        // TODO: - Update toolbar
    }
    
    func updateToolbarItems() {
        if !manager.isExpenseEditable() {
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            toolbar.items = [flexibleSpace, btnClone, flexibleSpace]
        }
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
        // TODO - Replace this with actual history details
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - Wire this up once the audit trail will be sent by the server.
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
        manager.fetchExpenseDetails(withExpenseId: expenseId!) { [weak self] (response) in
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
