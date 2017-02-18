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
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - ILoginService implementation
    /***********************************/
    
    func loginUser(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void)) {
        
        let payload = getPayloadForLogin(withOrganizationName: organizationName, userId: userId, password: password)
        
        serviceAdapter.post(destination: Constants.URLs.Login, payload: payload, headers: [:]) { (response) in
            switch(response) {
            case .Success(let success, let headers):
                
                // Since the login service provides the headers, we save it for the other services
                if let accessToken = headers[Constants.ResponseParameters.AccessToken] {
                    Singleton.sharedInstance.accessTokenHeader[Constants.ResponseParameters.AccessToken] = accessToken
                }
                
                let member = Member(JSON(success))
                completionHandler(Result.Success(member))
                
            case .Errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.Error(error))
                
            case .Failure(let description):
                completionHandler(Result.Failure(description))
            }
        }
    }
    
    
    func logoutUser() {
        serviceAdapter.post(destination: Constants.URLs.Logout, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            
        }
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
