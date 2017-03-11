//
//  ReviewSelectReportViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 11/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Protocol
/***********************************/
protocol ReviewSelectReportViewControllerDelegate: class {
    func reportSelected(_ report: Report)
}
/***********************************/
// MARK: - Properties
/***********************************/
class ReviewSelectReportViewController: BaseViewControllerWithTableView {
    
    let manager = ReviewSelectReportManager()
    
    var preSelectedReportId: String?
    
    weak var delegate: ReviewSelectReportViewControllerDelegate?
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.ViewControllerTitles.reviewSelectReport
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
        
        fetchReports()
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReviewSelectReportViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchReports()
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReviewSelectReportViewController {
    /**
     * Method to fetch currencies that will be displayed in the tableview.
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
extension ReviewSelectReportViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getReports().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reviewSelectReportTableViewCellIdentifier, for: indexPath) as! ReviewSelectReportTableViewCell
        cell.lblName.text = manager.getReportTitle(forIndexPath: indexPath)
        cell.lblAmount.text = manager.getReportAmount(forIndexPath: indexPath)
        cell.accessoryType = manager.getCellAccessoryType(forIndexPath: indexPath, preSelectedReportId: preSelectedReportId)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReviewSelectReportViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: false)
        delegate?.reportSelected(manager.getReports()[indexPath.row])
        _ = self.navigationController?.popViewController(animated: true)
    }
}
