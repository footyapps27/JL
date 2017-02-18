//
//  LoginService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ILoginService {
    
    /**
     * Login user
     */
    func loginUser(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void))
    
    /**
     * Logout
     */
    func logoutUser()
}

struct LoginService: ILoginService {
    
    var serviceAdapter = AlamofireNetworkAdapter()
    
    /**
     * Login user
     */
    func loginUser(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void)) {
        
        let payload = getPayloadForLogin(withOrganizationName: organizationName, userId: userId, password: password)
        
        serviceAdapter.post(destination: Constants.URLs.Login, payload: payload, headers: [:]) { (response) in
            switch(response) {
            case .Success(let success):
                
                // TODO: - Save the headers to singleton.
                let json = JSON(success)
                let member = Member(json)
                log.debug("Success \(member)")
            case .Errors(let error):
                log.debug("Error \(error)")
            case .Failure(let description):
                log.debug("Failure \(description)")
            }
        }
    }
    
    /**
     * Logout
     */
    func logoutUser() {
        
    }
}

extension LoginService {
    /**
     * Method to get payload from the company Id, user Id & password.
     */
    func getPayloadForLogin(withOrganizationName organizationName: String, userId: String, password: String) -> [String : String] {
        return [Constants.RequestParameters.Login.OrganizationName : organizationName,
                Constants.RequestParameters.Login.MemberName : userId,
                Constants.RequestParameters.Login.Password : password];
    }
}
