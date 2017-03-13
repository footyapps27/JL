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
    
    @IBOutlet weak var headerView: ReportDetailsHeaderView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var btnSubmit: UIBarButtonItem!
    
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    @IBOutlet weak var btnMoreOptions: UIBarButtonItem!
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will help the header update faster
        manager.report = report!
        headerView.updateView(withManager: manager)
        
        fetchReportDetails()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsViewController {
    func updateUIAfterSuccessfulResponse() {
        headerView.updateView(withManager: manager)
        tableView.reloadData()
        updateToolbarItems()
    }
    
    func updateToolbarItems() {
        if !manager.isReportEditable() {
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            
            let btnArchive = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: nil)
            btnArchive.title = "Archive"
            
            let btnViewAsPDF = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: nil)
            btnViewAsPDF.title = "View As PDF"
            
            toolbar.items = [flexibleSpace, btnArchive, flexibleSpace, btnViewAsPDF, flexibleSpace]
        }
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportDetailsViewController {
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func moreOptionsButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ReportDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getAuditHistories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.expenseDetailsAuditHistoryTableViewCellIdentifier, for: indexPath) as! ExpenseDetailsAuditHistoryTableViewCell
        
        cell.lblDescription.text = manager.getAuditHistoryDescription(forIndexPath: indexPath)
        cell.lblUserAndDate.text = manager.getAuditHistoryDetails(forIndexPath: indexPath)
        
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReportDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.CellHeight.expenseAuditHistoryCellHeight)
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
