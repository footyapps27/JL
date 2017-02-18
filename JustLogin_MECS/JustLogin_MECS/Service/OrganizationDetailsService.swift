//
//  OrganizationDetail.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IOrganizationDetailsService {
    
    /**
     * Get details of the organization the current logged in member is attached to.
     */
    func getOrganizationDetails(_ completionHandler:( @escaping (Result<Organization>) -> Void))
}

struct OrganizationDetailsService: IOrganizationDetailsService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - IOrganizationDetailsService implementation
    /***********************************/
    
    func getOrganizationDetails(_ completionHandler: @escaping ((Result<Organization>) -> Void)) {
        
        serviceAdapter.post(destination: Constants.URLs.OrganizationDetails, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .Success(let success):
                let organization = Organization(JSON(success))
                completionHandler(Result.Success(organization))
                
            case .Errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.Error(error))

            case .Failure(let description):
                completionHandler(Result.Failure(description))
            }
        }
    }
}
