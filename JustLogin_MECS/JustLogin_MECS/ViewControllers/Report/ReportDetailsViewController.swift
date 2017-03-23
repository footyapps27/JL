//
//  ReportDetailsViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportDetailsViewController: BaseViewControllerWithTableView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let manager = ReportDetailsManager()
    
    var report: Report?
    
    var caller: ReportDetailsCaller = ReportDetailsCaller.reportList
    
    @IBOutlet weak var headerView: ReportDetailsHeaderView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    var footerView: ReportDetailsFooterView = ReportDetailsFooterView.instanceFromNib()
    
    let segmentedControl = UISegmentedControl(items: ["Expenses", "More Details", "History"]) // TODO - Move to constants
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will help the header update faster
        manager.report = report!
        
        tableView.tableFooterView = footerView
        
        // Register for notification
        NotificationCenter.default.addObserver(self, selector: #selector(ReportDetailsViewController.fetchReportDetails), name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
        
        updateTableHeaderAndFooter()
        fetchReportDetails()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.Notifications.refreshReportDetails), object: nil)
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsViewController {
    func updateUIAfterSuccessfulResponse() {
        updateTableHeaderAndFooter()
        
        manager.updateToolBar(toolbar, caller: caller, delegate: self)
        tableView.reloadData()
    }
    
    func getHeaderViewWithSegmentedControl() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 48)) // TODO - Move to constants
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.frame = CGRect(x: 20, y: 10, width: view.frame.width - 40, height: 28)
        segmentedControl.selectedSegmentIndex = manager.getSelectedSegmentedControlIndex()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChange(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        return view
    }
    
    func updateTableHeaderAndFooter() {
        headerView.updateView(withManager: manager)
        footerView.updateView(withManager: manager)
    }
    
    func navigateToApproversList() {
        if report != nil {
            let approversListViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.approversListViewController) as! ApproversListViewController
            approversListViewController.report = report!
            approversListViewController.delegate = self
            // TODO - Create a utility function for this
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(approversListViewController, animated: true)
        } else {
            log.error("Report found nil while unwrapping in report details")
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportDetailsViewController {
    func segmentedControlValueChange(_ sender: UISegmentedControl) {
        manager.setSelectedSegmentedControlIndex(sender.selectedSegmentIndex)
        
        if manager.shouldDisplayFooter() {
            tableView.tableFooterView = footerView
        } else {
            tableView.tableFooterView = UIView()
        }
        
        let separatorStyle: UITableViewCellSeparatorStyle = manager.shouldHaveSeparator() ? .singleLine : .none
        tableView.separatorStyle = separatorStyle
        
        tableView.reloadData()
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ReportDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return manager.getCell(withTableView: tableView, atIndexPath: indexPath)
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReportDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderViewWithSegmentedControl()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getHeaderViewWithSegmentedControl().frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return manager.getHeightForRowAt(withTableView: tableView, atIndexPath: indexPath)
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReportDetailsViewController:ApproversListDelegate {
    func reportSubmitted() {
        fetchReportDetails()
        // Also inform the report and expense list to refresh itself with new data.
        NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshReportList), object: nil)
        NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.refreshExpenseList), object: nil)
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReportDetailsViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func fetchReportDetails() {
        showLoadingIndicator(disableUserInteraction: false)
        manager.fetchReportDetails(withReportId: report!.id) { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(let report):
                self.report = report
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
// MARK: - ReportDetailsToolBarActionDelegate
/***********************************/
extension ReportDetailsViewController: ReportDetailsToolBarActionDelegate {
    func barButtonItemTapped(_ sender: UIBarButtonItem) {
        manager.performActionForBarButtonItem(sender, caller: caller, onController: self)
    }
}
/***********************************/
// MARK: - RecordReimbursementDelegate
/***********************************/
extension ReportDetailsViewController: RecordReimbursementDelegate {
    func reportReimbursed() {
        fetchReportDetails()
    }
}
