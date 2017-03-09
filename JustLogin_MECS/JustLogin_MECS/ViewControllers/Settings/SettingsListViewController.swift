//
//  SettingsListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 9/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Properties
/***********************************/
class SettingsListViewController: BaseViewControllerWithTableView {
    
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblOrganization: UILabel!
    
    let manager = SettingsListManager()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension SettingsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension SettingsListViewController {
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        showLoadingIndicator(disableUserInteraction: true)
        manager.signOut { [weak self] (response) in
            guard let `self` = self else {
                log.error("Self reference missing in closure.")
                return
            }
            
            switch(response) {
            case .success(_):
                self.hideLoadingIndicator(enableUserInteraction: true)
                self.navigateToLaunchController()
            case .failure(_, let message):
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.hideLoadingIndicator(enableUserInteraction: true)
            }
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension SettingsListViewController {
    func navigateToLaunchController() {
        let mainNavigtionController = UIStoryboard(name: Constants.StoryboardIds.mainStoryboard, bundle: nil).instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainNavigtionController
    }
}
/***********************************/
// MARK: - UITableViewDataSource
/***********************************/
extension SettingsListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Hardcoded data
        return 3
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: - Hardcoded data
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.settingsListTableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = "Settings \(indexPath.row)"
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension SettingsListViewController: UITableViewDelegate {
}
