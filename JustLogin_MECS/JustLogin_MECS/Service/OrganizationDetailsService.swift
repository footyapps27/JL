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
    
    var serviceAdapter: NetworkAdapter = NetworkAdapterFactory.getNetworkAdapter()
    
    /***********************************/
    // MARK: - IOrganizationDetailsService implementation
    /***********************************/
    
    func getOrganizationDetails(_ completionHandler: @escaping ((Result<Organization>) -> Void)) {
        
        serviceAdapter.post(destination: Constants.URLs.Organization.organizationDetails, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                let organization = Organization(withJSON: JSON(success))
                completionHandler(Result.success(organization))
                
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))

            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
}
