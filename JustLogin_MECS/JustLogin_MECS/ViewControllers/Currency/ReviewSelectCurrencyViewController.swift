//
//  ReviewSelectCurrencyViewController.swift
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
protocol ReviewSelectCurrencyViewControllerDelegate: class {
    func currencySelected(_ currency: Currency)
}
/***********************************/
// MARK: - Properties
/***********************************/
class ReviewSelectCurrencyViewController: BaseViewControllerWithTableView {
    
    let manager = ReviewSelectCurrencyManager()
    
    var preSelectedCurrency: Currency?
    
    weak var delegate: ReviewSelectCurrencyViewControllerDelegate?
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.ViewControllerTitles.reviewSelectCurrency
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReviewSelectCurrencyViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchCurrencies()
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: - Navigate to add category is the user has privileges
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReviewSelectCurrencyViewController {
    /**
     * Method to fetch currencies that will be displayed in the tableview.
     */
    func fetchCurrencies() {
        
        manager.fetchCurrencies { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            switch(response) {
            case .success(_):
                self.tableView.reloadData()
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            case .failure(_, let message):
                // TODO: - Handle the empty table view screen.
                Utilities.showErrorAlert(withMessage: message, onController: self)
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension ReviewSelectCurrencyViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getCurrencies().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO - Show the checkmark if preSelectedCategory is present.
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.defaultTableViewCellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: Constants.CellIdentifiers.defaultTableViewCellIdentifier)
        }
        
        cell?.textLabel?.text = manager.getCurrencyCode(forIndexPath: indexPath)
        cell?.accessoryType = manager.getCellAccessoryType(forIndexPath: indexPath, preSelectedCurrency: preSelectedCurrency)
        return cell!
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReviewSelectCurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: false)
        delegate?.currencySelected(manager.getCurrencies()[indexPath.row])
        _ = self.navigationController?.popViewController(animated: true)
    }
}
