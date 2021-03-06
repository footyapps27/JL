//
//  ApprovalListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ApprovalListViewController: BaseViewControllerWithTableView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let manager = ApprovalListManager()
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for notification
        NotificationCenter.default.addObserver(self, selector: #selector(ApprovalListViewController.fetchApprovals), name: Notification.Name(Constants.Notifications.refreshApprovalList), object: nil)
        
        updateUI()
        
        fetchApprovals()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.Notifications.refreshApprovalList), object: nil)
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ApprovalListViewController {
    func updateUI() {
        self.navigationItem.title = Constants.ViewControllerTitles.approvals
        
        tableView.isHidden = true
        
        addSearchController(toTableView: tableView, withSearchResultsUpdater: self)
        
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
    }
    
    func navigateToReportDetails(forReport report: Report) {
        let reportDetailsViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Report.reportDetailsViewController) as! ReportDetailsViewController
        reportDetailsViewController.caller = ReportDetailsCaller.approvalList
        reportDetailsViewController.report = report
        Utilities.pushControllerAndHideTabbarForChildOnly(fromController: self, toController: reportDetailsViewController)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ApprovalListViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchApprovals()
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ApprovalListViewController {
    /**
     * Method to fetch approvals that will be displayed in the tableview.
     */
    func fetchApprovals() {
        
        if !refreshControl.isRefreshing {
            showLoadingIndicator(disableUserInteraction: false)
        }
        
        manager.fetchApprovals { [weak self] (response) in
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
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ApprovalListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getApprovals().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.approvalListTableViewCellIdentifier, for: indexPath) as! ApprovalListTableViewCell
        cell.lblReportName.text = manager.getReportTitle(forIndexPath: indexPath)
        cell.lblEmployeeName.text = manager.getSubmitterName(forIndexPath: indexPath)
        cell.lblAmount.text = manager.getFormattedReportAmount(forIndexPath: indexPath)
        cell.lblStatus.text = manager.getReportStatus(forIndexPath: indexPath)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ApprovalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.approvalListCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToReportDetails(forReport: manager.getApprovals()[indexPath.row])
    }
}
/***********************************/
// MARK: - UISearchResultsUpdating
/***********************************/
extension ApprovalListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}
