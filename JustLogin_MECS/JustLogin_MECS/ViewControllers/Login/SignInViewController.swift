//
//  SignInViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 5/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: BaseViewController {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    @IBOutlet weak var txtCompanyId: UITextField!
    
    @IBOutlet weak var txtUserId: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let manager: SignInManager = SignInManager()
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        navigationItem.leftBarButtonItems = [cancel]
    }
    
    /***********************************/
    // MARK: - Helpers
    /***********************************/
    
    /**
     Method to dismiss the controller when cancel is tapped.
     */
    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     On successful sign up, the user is taken to the dashboard.
     */
    @IBAction func signInTapped(_ sender: UIButton) {
        
        let validationResponse = manager.validateLoginParameters(organizationName: txtCompanyId.text!, userId: txtUserId.text!, password: txtPassword.text!)
        
        switch validationResponse {
        case .failure(_ , let errorMessage):
            Utilities.showErrorAlert(withMessage: errorMessage, onController: self)
        case .success(_):
            callLoginService()
        }
    }
    
    /**
     * Call the login service to authenticate the member.
     */
    private func callLoginService() {
        
        // TODO: - Add the loading indicator.
        manager.login(withOrganizationName: txtCompanyId.text!, userId: txtUserId.text!, password: txtPassword.text!) { [weak self] (result) in
            guard let `self` = self else {
                log.error("self reference missing in closure.")
                return
            }
            
            switch(result) {
            case .success( _):
                
                // Inform the parent that the user logged in successfully, and the member that has logged in.
                NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.loginSuccessful), object: nil)
                self.dismiss(animated: false, completion: nil)
                
            case .failure(_ , let message):
                Utilities.showErrorAlert(withMessage: message, onController: self)
            }
        }
    }
}

/***********************************/
// MARK: - Keyboard event listeners
/***********************************/
extension SignInViewController {
    override func keyboardWillShow(_ notification: Notification) {
        if !isKeyboardVisible {
            super.keyboardWillShow(notification)
            Utilities.adjustInsetForKeyboardShow(true, notification: notification, scrollView: scrollView)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        Utilities.adjustInsetForKeyboardShow(false, notification: notification, scrollView: scrollView)
    }
}
