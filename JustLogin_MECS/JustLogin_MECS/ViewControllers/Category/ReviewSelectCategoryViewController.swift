//
//  ReviewSelectCategoryViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 10/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Protocol
/***********************************/
protocol ReviewSelectCategoryViewControllerDelegate: class {
    func categorySelected(_ category: Category)
}
/***********************************/
// MARK: - Properties
/***********************************/
class ReviewSelectCategoryViewController: BaseViewControllerWithTableView {
    
    let manager = ReviewSelectCategoryManager()
    
    var preSelectedCategory: Category?
    
    weak var delegate: ReviewSelectCategoryViewControllerDelegate?
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl(toTableView: tableView, withAction: #selector(refreshTableView(_:)))
        
        addBarButtonItems()
    }
}

/***********************************/
// MARK: - Helpers
/***********************************/
extension ReviewSelectCategoryViewController {
    
    func addBarButtonItems() {
        // TODO: - Check if the button should be enabled based on role.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReviewSelectCategoryViewController {
    
    func refreshTableView(_ refreshControl: UIRefreshControl) {
        fetchCategories()
    }
    
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: - Navigate to add category is the user has privileges
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReviewSelectCategoryViewController {
    /**
     * Method to fetch categories that will be displayed in the tableview.
     */
    func fetchCategories() {
        
        manager.fetchCategories { [weak self] (response) in
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
extension ReviewSelectCategoryViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getCategories().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO - Show the checkmark if preSelectedCategory is present.
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reviewSelectCategoryTableViewCellIdentifier, for: indexPath) as! ReviewSelectCategoryTableViewCell
        
        cell.lblCategoryName.text = manager.getCategoryName(forIndexPath: indexPath)
        cell.imgView.image = UIImage(named: manager.getCategoryImageName(forIndexPath: indexPath))
        cell.accessoryType = manager.getCellAccessoryType(forIndexPath: indexPath, preSelectedCategory: preSelectedCategory)
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension ReviewSelectCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: false)
        delegate?.categorySelected(manager.categories[indexPath.row])
        _ = self.navigationController?.popViewController(animated: true)
    }
}
