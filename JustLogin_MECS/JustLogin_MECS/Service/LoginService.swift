//
//  LoginService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IAuthenticationService {
    
    /**
     * Login user
     */
    func loginUser(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void))
    
    /**
     * Logout
     */
    func logoutUser(_ completionHandler:( @escaping (Result<Void>) -> Void))
}

struct AuthenticationService: IAuthenticationService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - ILoginService implementation
    /***********************************/
    
    func loginUser(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void)) {
        
        let payload = getPayloadForLogin(withOrganizationName: organizationName, userId: userId, password: password)
        
        serviceAdapter.post(destination: Constants.URLs.login, payload: payload, headers: nil) { (response) in
            switch(response) {
            case .success(let success, let headers):
                
                // Since the login service provides the headers, we save it for the other services
                if let accessToken = headers?[Constants.ResponseParameters.accessToken] {
                    Singleton.sharedInstance.accessTokenHeader[Constants.ResponseParameters.accessToken] = accessToken
                }
                
                let member = Member(withJSON: JSON(success))
                completionHandler(Result.success(member))
                
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
                
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    
    func logoutUser(_ completionHandler:( @escaping (Result<Void>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.logout, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(_,_):
                completionHandler(Result.success())
                
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
                
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
}

extension AuthenticationService {
    /**
     * Method to get payload from the company Id, user Id & password.
     */
    func getPayloadForLogin(withOrganizationName organizationName: String, userId: String, password: String) -> [String : String] {
        return [Constants.RequestParameters.Login.organizationName : organizationName,
                Constants.RequestParameters.Login.memberName : userId,
                Constants.RequestParameters.Login.password : password];
    }
}
