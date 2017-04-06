//
//  SignInViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 5/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - SignInDelegate Protocol Declaration
/***********************************/
protocol SignInDelegate: class {
    func loginSuccessful()
}
/***********************************/
// MARK: - Properties
/***********************************/
class SignInViewController: BaseViewController {

    @IBOutlet weak var txtCompanyId: UITextField!
    
    @IBOutlet weak var txtUserId: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: SignInDelegate?
    
    let manager: SignInManager = SignInManager()
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension SignInViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        addBarButton()
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension SignInViewController {
    func updateUI() {
        view.backgroundColor = Color.background.value
        btnSignIn.backgroundColor = Color.theme.value
    }
    
    func addBarButton() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItems = [cancel]
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension SignInViewController {
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
        
//        txtCompanyId.text = "fargotest"
//        txtUserId.text = "admin"
//        txtPassword.text = "admin"
        
        let validationResponse = manager.validateLoginParameters(organizationName: txtCompanyId.text!, userId: txtUserId.text!, password: txtPassword.text!)
        view.endEditing(true)
        switch validationResponse {
        case .failure(_ , let errorMessage):
            Utilities.showErrorAlert(withMessage: errorMessage, onController: self)
        case .success(_):
            callLoginService()
        }
    }
}
/***********************************/
// MARK: - Service
/***********************************/
extension SignInViewController {
    /**
     * Call the login service to authenticate the member.
     */
    fileprivate func callLoginService() {
        showLoadingIndicator(disableUserInteraction: true)
        manager.login(withOrganizationName: txtCompanyId.text!, userId: txtUserId.text!, password: txtPassword.text!) { [weak self] (result) in
            
            guard let `self` = self else {
                log.error("self reference missing in closure.")
                return
            }
            
            self.hideLoadingIndicator(enableUserInteraction: true)
            switch(result) {
            case .success( _):
                // Inform the parent that the user logged in successfully, and the member that has logged in.
                self.delegate?.loginSuccessful()
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
