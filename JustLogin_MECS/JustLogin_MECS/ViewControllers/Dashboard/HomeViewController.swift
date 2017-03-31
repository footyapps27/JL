//
//  HomeViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 6/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: BaseViewController {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    let manager = HomeScreenManager()
    
    @IBOutlet weak var lblMemberName: UILabel!
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension HomeViewController {
    
    @IBAction func addExpenseTapped(_ sender: UIButton) {
        navigateToAddExpense()
    }
    
    @IBAction func addReportTapped(_ sender: UIButton) {
        navigateToAddReport()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension HomeViewController {
    func updateUI() {
        self.navigationItem.title = Singleton.sharedInstance.organization?.name
        view.backgroundColor = Color.theme.value
        lblMemberName.text = manager.getMemberName()
    }
    
    /**
     * Navigate to the Add Expense. 
     * This will add a navigation controller before presenting the add expense controller
     */
    func navigateToAddExpense() {
        let addEditExpenseViewController = UIStoryboard(name: Constants.StoryboardIds.expenseStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Expense.addEditExpenseViewController) as! AddEditExpenseViewController
        addEditExpenseViewController.delegate = self
        let navigationController = UINavigationController.init(rootViewController: addEditExpenseViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    /**
     * Navigate to the Add Expense.
     * This will add a navigation controller before presenting the add report controller
     */
    func navigateToAddReport() {
        let addEditReportViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.Report.addEditReportViewController) as! AddEditReportViewController
        addEditReportViewController.delegate = self
        let navigationController = UINavigationController.init(rootViewController: addEditReportViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
/***********************************/
// MARK: - AddEditExpenseDelegate
/***********************************/
extension HomeViewController: AddEditExpenseDelegate {
    func expenseCreatedOrModified() {
         _ = UIStoryboard(name: Constants.StoryboardIds.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: manager.getDashboardIdentifier()) as! UITabBarController
        // TODO = Here we need to navigate to the expense list controller.
    }
}
/***********************************/
// MARK: - AddEditReportDelegate
/***********************************/
extension HomeViewController: AddEditReportDelegate {
    func reportCreatedOrModified() {
        _ = UIStoryboard(name: Constants.StoryboardIds.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: manager.getDashboardIdentifier()) as! UITabBarController
        // TODO = Here we need to navigate to the report list controller.
    }
}
