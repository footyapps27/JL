//
//  ReportListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit


class ReportListViewController: BaseViewControllerWithTableView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let manager = ReportListManager()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for notification
        NotificationCenter.default.addObserver(self, selector: #selector(ReportListViewController.fetchReports), name: Notification.Name(Constants.Notifications.refreshReportList), object: nil)
        
        updateUI()
        
        fetchReports()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.Notifications.refreshReportList), object: nil)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportListViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchReports()
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        navigateToAddReport()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportListViewController {
    /**
     * Method to add bar button items.
     */
    func addBarButtonItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    func updateUI() {
        self.navigationItem.title = Constants.ViewControllerTitles.reports
        
        tableView.isHidden = true
        
        addSearchController(toTableView: tableView, withSearchResultsUpdater: self)
        
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
        
        addBarButtonItems()
    }
    
    func navigateToAddReport() {
        let addEditReportViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Report.addEditReportViewController) as! AddEditReportViewController
        addEditReportViewController.delegate = self
        Utilities.pushControllerAndHideTabbarForChildOnly(fromController: self, toController: addEditReportViewController)
    }
    
    func navigateToReportDetails(forReport report: Report) {
        let reportDetailsViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Report.reportDetailsViewController) as! ReportDetailsViewController
        reportDetailsViewController.report = report
        Utilities.pushControllerAndHideTabbarForChildOnly(fromController: self, toController: reportDetailsViewController)
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReportListViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func fetchReports() {
        
        if !refreshControl.isRefreshing {
            showLoadingIndicator(disableUserInteraction: false)
        }
        
        manager.fetchReports { [weak self] (response) in
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
extension ReportListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getReports().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reportListTableViewCellIdentifier, for: indexPath) as! ReportListTableViewCell
        cell.lblReportName.text = manager.getReportTitle(forIndexPath: indexPath)
        cell.lblDate.text = manager.getReportDuration(forIndexPath: indexPath)
        cell.lblAmount.text = manager.getFormattedReportAmount(forIndexPath: indexPath)
        cell.lblStatus.text = manager.getReportStatus(forIndexPath: indexPath)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReportListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.reportListCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToReportDetails(forReport: manager.getReports()[indexPath.row])
    }
}
/***********************************/
// MARK: - UISearchResultsUpdating
/***********************************/
extension ReportListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
/***********************************/
// MARK: - AddReportDelegate
/***********************************/
extension ReportListViewController: AddReportDelegate {
    func reportCreated() {
        fetchReports()
    }
}
