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
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0,0,0,0)
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
        
        activityIndicator?.startAnimating()
        
        let validationResponse = manager.validateLoginParameters(organizationName: txtCompanyId.text!, userId: txtUserId.text!, password: txtPassword.text!)
        
        switch validationResponse {
        case .Failure(let errorMessage):
            Utilities.showErrorAlert(withMessage: errorMessage, onController: self)
        default:
            // Call web service
            //callLoginService()
            break
        }
    }
    
    private func callLoginService() {
        manager.login(withOrganizationName: txtCompanyId.text!, userId: txtUserId.text!, password: txtPassword.text!) { (member) in
            print(member)
            // Inform the parent that the user logged in successfully, and the user that has logged in.
            let user = User.init(name: "John Doe", role: .Submitter)
            NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.LoginSuccessful), object: user)
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension SignInViewController {
    override func keyboardWillShow(_ notification: Notification) {
        if !isKeyboardVisible {
            super.keyboardWillShow(notification)
            Utilities.adjustInsetForKeyboardShow(show: true, notification: notification, scrollView: scrollView)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        Utilities.adjustInsetForKeyboardShow(show: false, notification: notification, scrollView: scrollView)
    }
}
