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
    
    // For image selection.
    let imagePickerController = UIImagePickerController()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension SettingsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        imagePickerController.delegate = self
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
        let pickPhoto = UIAlertAction(title: LocalizedString.pickPhoto, style: .default) { void in
            self.selectImageFromGallery()
        }
        
        let openCamera = UIAlertAction(title: LocalizedString.openCamera, style: .default) { void in
            self.selectImageUsingCamera()
        }
        
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [pickPhoto, openCamera ], onController: self)
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
    
    func selectImageFromGallery() {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func selectImageUsingCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            present(imagePickerController,animated: true,completion: nil)
        } else {
            log.debug("Camera not found")
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
// MARK: - UIImagePickerControllerDelegate
/***********************************/
extension SettingsListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgVwProfile.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
