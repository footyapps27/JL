//
//  BaseViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 6/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    var activityIndicator: NVActivityIndicatorView?
    
    var isKeyboardVisible: Bool = false
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationListeners()
    }

    deinit {
        removeKeyboardNotificationListeners()
    }
}
/***********************************/
// MARK: - Public Methods
/***********************************/
extension BaseViewController {
    
    func showLoadingIndicator(disableUserInteraction: Bool) {
        activityIndicator?.startAnimating()
        if disableUserInteraction {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func hideLoadingIndicator(enableUserInteraction: Bool) {
        activityIndicator?.stopAnimating()
        if enableUserInteraction {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
/***********************************/
// MARK: - Notification Listeners
/***********************************/
extension BaseViewController {
    func keyboardWillShow(_ notification: Notification) {
        isKeyboardVisible = true
    }
    
    func keyboardWillHide(_ notification: Notification) {
        isKeyboardVisible = false
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension BaseViewController {

    fileprivate func addKeyboardNotificationListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    fileprivate func removeKeyboardNotificationListeners() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func addActivityIndicator() {
        
        // TODO: - Put this value in constants.
        let frame = CGRect(x: (UIScreen.main.bounds.size.width * 0.5) - CGFloat(Constants.UISize.activityIndicatorHeightWidth),
                           y: (UIScreen.main.bounds.size.height * 0.5) - CGFloat(Constants.UISize.activityIndicatorHeightWidth),
                           width: CGFloat(Constants.UISize.activityIndicatorHeightWidth),
                           height: CGFloat(Constants.UISize.activityIndicatorHeightWidth))
        
        activityIndicator =  NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.lightGray, padding: CGFloat(0))
        
        self.view.addSubview(activityIndicator!)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    }
}
