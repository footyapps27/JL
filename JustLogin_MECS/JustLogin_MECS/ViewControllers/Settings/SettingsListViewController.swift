//
//  SettingsListViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 9/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
/***********************************/
// MARK: - Properties
/***********************************/
class SettingsListViewController: BaseViewControllerWithTableView {
    
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblOrganization: UILabel!
    
    let manager = SettingsListManager()
    let imagePickerUtility = ImagePickerControllerUtility()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension SettingsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        imagePickerUtility.delegate = self
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
    
    func profileImageTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        imagePickerUtility.showOptionsForSelectingPhoto(onController: self)
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension SettingsListViewController {
    func updateUI() {
        self.navigationItem.title = Constants.ViewControllerTitles.settings
        lblOrganization.text = manager.getOrganizationName()
        lblRole.text = manager.getRole()
        updateProfileImage()
    }
    
    func updateProfileImage() {
        // Add Tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))
        imgVwProfile.isUserInteractionEnabled = true
        imgVwProfile.addGestureRecognizer(tapGestureRecognizer)
        // Load photo from the server or cache
        let placeholderImage = UIImage(named: Constants.UIImageNames.profile)!
        if manager.getProfileImageUrl() != nil {
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: imgVwProfile.frame.size,
                radius: imgVwProfile.frame.size.width/2
            )
            imgVwProfile.af_setImage(
                withURL: manager.getProfileImageUrl()!,
                placeholderImage: placeholderImage,
                filter: filter
            )
        } else {
            imgVwProfile.image = placeholderImage
        }
    }
    
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
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return manager.getFields().count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getFields()[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.settingsListTableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = manager.getFields()[indexPath.section][indexPath.row].rawValue
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension SettingsListViewController: UITableViewDelegate {
    
}
/***********************************/
// MARK: - UITableViewDelegate
/***********************************/
extension SettingsListViewController: ImagePickerControllerUtilityDelegate {
    
    func didFinishSelectingImage(atURL url: URL) {
        let urlRequest = URLRequest(url: url)
        let imageDownloader = UIImageView.af_sharedImageDownloader
        _ = imageDownloader.imageCache?.removeImage(for: urlRequest, withIdentifier: nil)
        imageDownloader.sessionManager.session.configuration.urlCache?.removeCachedResponse(for: urlRequest)
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.imgVwProfile.frame.size,
            radius: self.imgVwProfile.frame.size.width/2
        )
        self.imgVwProfile.af_setImage(
            withURL: url,
            placeholderImage: nil,
            filter: filter
        )
        
        showLoadingIndicator(disableUserInteraction: false)
        
        manager.updateProfileImage(imageURL: url, completionHandler: { (response) in
            switch(response) {
            case .success(_):
                
                self.hideLoadingIndicator(enableUserInteraction: true)
            case .failure(_, let message):
                Utilities.showErrorAlert(withMessage: message, onController: self)
                self.hideLoadingIndicator(enableUserInteraction: true)
            }
        })
    }
    
    func didFail() {
        
    }
}
