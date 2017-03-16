//
//  ApproversListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 15/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Protocol
/***********************************/
protocol ApproversListDelegate: class {
    func reportSubmitted()
}

/***********************************/
// MARK: - Properties
/***********************************/
class ApproversListViewController: BaseViewControllerWithTableView {
    
    let manager = ApproversListManager()
    
    var report: Report?
    
    weak var delegate: ApproversListDelegate?
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension ApproversListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        
        addSearchController(toTableView: tableView, withSearchResultsUpdater: self)
        
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
        
        addBarButtonItems()
        
        fetchApprovers()
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ApproversListViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchApprovers()
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.indexPathForSelectedRow != nil {
            processReport()
        } else {
            Utilities.showErrorAlert(withMessage: "Please select approver for submitting the report to.", onController: self)
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ApproversListViewController {
    /**
     * Method to add bar button items.
     */
    func addBarButtonItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(rightBarButtonTapped(_:)))// TODO - Move to constants
    }
    
    /**
     * Method to show success alert when a report is successfully submitted.
     */
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Report successfully submitted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true)
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ApproversListViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func fetchApprovers() {
        
        if !refreshControl.isRefreshing {
            showLoadingIndicator(disableUserInteraction: false)
        }
        
        manager.fetchApprovers { [weak self] (response) in
            // TODO: - Add loading indicator
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
    
    /**
     * Method to process a report.
     */
    func processReport() {
        if report != nil {
            
            if !refreshControl.isRefreshing {
                showLoadingIndicator(disableUserInteraction: false)
            }
            // Unwrapping here since we have checked the condition on button click.
            let approver = manager.getApprovers()[tableView.indexPathForSelectedRow!.row]
            manager.processReport(report!, withApprover: approver, completionHandler: { [weak self] (response) in
                guard let `self` = self else {
                    log.error("Self reference missing in closure.")
                    return
                }
                
                switch(response) {
                case .success(_):
                    // TODO: - Move to constants
                    self.delegate?.reportSubmitted()
                    self.refreshControl.isRefreshing ? self.refreshControl.endRefreshing() : self.hideLoadingIndicator(enableUserInteraction: true)
                    self.showSuccessAlert()
                case .failure(_, let message):
                    Utilities.showErrorAlert(withMessage: message, onController: self)
                    self.refreshControl.isRefreshing ? self.refreshControl.endRefreshing() : self.hideLoadingIndicator(enableUserInteraction: true)
                }
            })
        } else {
            log.error("Report object found nil while submitting.")
        }
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ApproversListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getApprovers().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.approversListTableViewCellIdentifier, for: indexPath) as! ApproversListTableViewCell
        // TODO - Map the image view here
        cell.lblName.text = manager.getMemberName(forIndexPath: indexPath)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ApproversListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        return indexPath
    }
}
/***********************************/
// MARK: - UISearchResultsUpdating
/***********************************/
extension ApproversListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
