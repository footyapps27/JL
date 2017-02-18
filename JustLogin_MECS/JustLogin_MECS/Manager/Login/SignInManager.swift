//
//  SignInManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 19/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for SignInViewController
 */
struct SignInManager {
    
    var loginService: ILoginService = LoginService()
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    func login(withOrganizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void)) {
        
    }
}
