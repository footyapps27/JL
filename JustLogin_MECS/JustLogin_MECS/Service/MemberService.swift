//
//  MemberService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 15/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IMemberService {
    
    /**
     * Method to retrieve approvers for the current user.
     */
    func getApproversForCurrentUser(_ completionHandler:( @escaping (Result<[Member]>) -> Void))
}

struct MemberService : IMemberService {
    
    var serviceAdapter: NetworkAdapter = NetworkConfiguration.getNetworkAdapter()
    
    /***********************************/
    // MARK: - IMemberService implementation
    /***********************************/
    
    func getApproversForCurrentUser(_ completionHandler:( @escaping (Result<[Member]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Member.getApprovers, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                var allApprovers: [Member] = []
                if let jsonMembers = success[Constants.ResponseParameters.members] as? [Any] {
                    for approver in jsonMembers {
                        allApprovers.append(Member(withJSON: JSON(approver)))
                    }
                }
                completionHandler(Result.success(allApprovers))
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
}
