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
    var organizationDetailsService: IOrganizationDetailsService = OrganizationDetailsService()
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    /**
     * This method will authenticate the user & save the details in Singleton.
     * It will also call the organization details.
     * If any of the two fail, and error response will be returned.
     */
    func login(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (ManagerResponseToController<Member>) -> Void)) {
        
        loginService.loginUser(withOrganizationName: organizationName, userId: userId, password: password) { (result) in
            
            switch(result) {
            case .Success(let member):
                
                // Now call the organization detail service
                self.organizationDetailsService.getOrganizationDetails({ (organizationResult) in
                    
                    switch(organizationResult) {
                    case .Success(let organization):
                        // Storing this in the Singleton, since it will be used all across the app.
                        Singleton.sharedInstance.organization = organization
                        Singleton.sharedInstance.member = member
                        completionHandler(ManagerResponseToController.Success(member))
                    case .Error(let serviceError):
                        // TODO: - Need to send the correct message
                        completionHandler(ManagerResponseToController.Failure(code: serviceError.code, message:serviceError.message))
                    case .Failure(let message):
                        // TODO: - Need to send the correct message
                        completionHandler(ManagerResponseToController.Failure(code: "", message:message))
                    }
                })
            case .Error(let serviceError):
                // TODO: - Parse the error here & send a
                completionHandler(ManagerResponseToController.Failure(code: serviceError.code, message:serviceError.message))
            case .Failure(let message):
                // TODO: - Need to send the correct message
                completionHandler(ManagerResponseToController.Failure(code: "", message:message))
            }
        }
    }
    
    /**
     * Check if none of the requried fields are empty.
     */
    func validateLoginParameters(organizationName: String, userId: String, password: String) -> ManagerResponseToController<Bool> {
        
        var error = false
        
        if organizationName.characters.count == 0 { error = true }
        
        if userId.characters.count == 0 { error = true }
        
        if password.characters.count == 0 { error = true }
        
        return error
            ? ManagerResponseToController.Failure(code: "", message: "All fields are mandatory") // TODO: - Move to constants
            : ManagerResponseToController.Success(true)
    }
}
