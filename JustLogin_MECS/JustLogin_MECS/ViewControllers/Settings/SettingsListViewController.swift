//
//  SettingsListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 9/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class SettingsListViewController: BaseViewControllerWithTableView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblOrganization: UILabel!
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /***********************************/
    // MARK: - Actions
    /***********************************/
    
    
    /***********************************/
    // MARK: - Helpers
    /***********************************/
    
}

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

extension SettingsListViewController: UITableViewDelegate {
}
