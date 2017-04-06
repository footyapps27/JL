//
//  ImagePickerControllerUtility.swift
//  JustLogin_MECS
//
//  Created by Samrat on 31/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - ImagePickerControllerUtilityDelegate
/***********************************/
protocol ImagePickerControllerUtilityDelegate: class {
    
    func didFinishSelectingImage(atURL url: URL)
    
    // TODO - Need to send the correct error message along with this.
    func didFail()
}

/***********************************/
// MARK: - Properties
/***********************************/
class ImagePickerControllerUtility: NSObject {
    
    let imagePickerController = UIImagePickerController()
    weak var delegate: ImagePickerControllerUtilityDelegate?
    
    override init() {
        super.init()
        imagePickerController.delegate = self
    }
}
/***********************************/
// MARK: - Public Methods
/***********************************/
extension ImagePickerControllerUtility {
    
    func showOptionsForSelectingPhoto(onController controller: BaseViewController) {
        let pickPhoto = UIAlertAction(title: LocalizedString.pickPhoto, style: .default) { [weak self] void in
            self?.selectImageFromGallery(onController: controller)
        }
        
        let openCamera = UIAlertAction(title: LocalizedString.openCamera, style: .default) { [weak self] void in
            self?.selectImageUsingCamera(onController: controller)
        }
        
        Utilities.showActionSheet(withTitle: nil, message: nil, actions: [pickPhoto, openCamera ], onController: controller)
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension ImagePickerControllerUtility {
    
    func selectImageFromGallery(onController controller: BaseViewController) {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePickerController.modalPresentationStyle = .fullScreen
        controller.present(imagePickerController, animated: true, completion: nil)
    }
    
    func selectImageUsingCamera(onController controller: BaseViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            controller.present(imagePickerController,animated: true,completion: nil)
        } else {
            log.debug("Camera not found")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
/***********************************/
// MARK: - UIImagePickerControllerDelegate
/***********************************/
extension ImagePickerControllerUtility: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let data = UIImageJPEGRepresentation(pickedImage, 0.8) {
                let fileName = getDocumentsDirectory().appendingPathComponent("temp.png")
                try? data.write(to: fileName, options: [Data.WritingOptions.atomic])
                delegate?.didFinishSelectingImage(atURL: fileName)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
