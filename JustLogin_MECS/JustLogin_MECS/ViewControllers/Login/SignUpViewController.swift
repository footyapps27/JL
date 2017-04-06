//
//  SignUpViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 5/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - SignUpDelegate Protocol Declaration
/***********************************/
protocol SignUpDelegate: class {
    func signUpSuccessful()
}
/***********************************/
// MARK: - Properties
/***********************************/
class SignUpViewController: BaseViewController {
    
    weak var delegate: SignUpDelegate?
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension SignUpViewController {
    
    override func viewDidLoad() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        navigationItem.leftBarButtonItems = [cancel]
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension SignUpViewController {
    /**
     Method to dismiss the controller when cancel is tapped.
     */
    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     On successful sign up, the user is taken to the dashboard.
     */
    @IBAction func signUpTapped(_ sender: UIButton) {
        // TODO: - Add the validations
        // Navigate to dashboard if successful, else show the error message.
        // For demo, now we are navigating to Admin flow from here.
        
        // Inform the parent that the user logged in successfully, and the user that has logged in.
        delegate?.signUpSuccessful()
        dismiss(animated: false, completion: nil)
    }
}
