//
//  SignUpViewController.swift
//  JustLogin_MECS
//
//  Created by Samrat on 5/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        navigationItem.leftBarButtonItems = [cancel]
    }
    
    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
