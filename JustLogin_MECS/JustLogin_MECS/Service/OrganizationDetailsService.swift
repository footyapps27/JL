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
     * Organization Details
     */
    func getOrganizationDetails(_ completionHandler:( @escaping (Result<Organization>) -> Void))
}

struct OrganizationDetailsService: IOrganizationDetailsService {
    
    var serviceAdapter = AlamofireNetworkAdapter()
    
    func getOrganizationDetails(_ completionHandler: @escaping ((Result<Organization>) -> Void)) {
        
        serviceAdapter.post(destination: Constants.URLs.OrganizationDetails, payload: [:], headers: ["AccessToken":"bcfe0cb7-0b83-488d-a014-7644d3804619"]) { (response) in
            switch(response) {
            case .Success(let success):
                let json = JSON(success)
                let organization = Organization(json)
                log.debug("Success \(organization)")
            case .Errors(let error):
                log.debug("Error \(error)")
            case .Failure(let description):
                log.debug("Failure \(description)")
            }
        }
    }
}
