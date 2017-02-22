//
//  SignInManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct SignInManager {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    var loginService: ILoginService = LoginService()
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    /**
     * Login to
     */
    func login(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void)) {
        loginService.loginUser(withOrganizationName: organizationName, userId: userId, password: password, completionHandler: completionHandler)
    }
    
    
    func validateLoginParameters(organizationName: String, userId: String, password: String) -> ValidationResponse {
        
        var error = false
        
        if organizationName.characters.count == 0 {
            error = true
        }
        
        if userId.characters.count == 0 {
            error = true
        }
        
        if password.characters.count == 0 {
            error = true
        }
        
        return error
            ? ValidationResponse.Failure("All fields are mandatory") // TODO: - Move to constants
            : ValidationResponse.Success
    }
}
