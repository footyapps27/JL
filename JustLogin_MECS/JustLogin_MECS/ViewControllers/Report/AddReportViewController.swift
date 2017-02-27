//
//  AddReportViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddReportViewController: BaseViewControllerWithTableView {
    /***********************************/
    // MARK: - Properties
    /***********************************/
    @IBOutlet weak var tableView: UITableView!
    
    let manager = AddReportManager()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtonItems()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension AddReportViewController {
    /**
     * Method to add bar button items.
     */
    func addBarButtonItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension AddReportViewController {
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: - Validate & call the service
        addReport()
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension AddReportViewController {
    /**
     * Method to fetch expenses that will be displayed in the tableview.
     */
    func addReport() {
        
        showLoadingIndicator(disableUserInteraction: true)
        
        var report = Report()
        report.title = "Test title from iOS"
        report.startDate = Date()
        report.endDate = Date().addingTimeInterval(6000)
        report.businessPurpose = "iOS biz purpose"
        
        manager.addReport(report) { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.hideLoadingIndicator(enableUserInteraction: true)
                _ = self.navigationController?.popViewController(animated: true)
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
extension AddReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getReportFields().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reportListTableViewCellIdentifier, for: indexPath) as! ReportListTableViewCell
//        cell.lblReportName.text = manager.getReportTitle(forIndexPath: indexPath)
//        cell.lblDate.text = manager.getReportDuration(forIndexPath: indexPath)
//        cell.lblAmount.text = manager.getFormattedReportAmount(forIndexPath: indexPath)
//        cell.lblStatus.text = manager.getReportStatus(forIndexPath: indexPath)
        return UITableViewCell()
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension AddReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.reportListCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
