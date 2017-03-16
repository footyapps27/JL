//
//  ApprovalService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 15/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

protocol IApprovalService {
    /**
     * Method to retrieve all reports.
     */
    func getAllApprovals(_ completionHandler:( @escaping (Result<[Report]>) -> Void))
}

struct ApprovalService : IApprovalService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()

    /***********************************/
    // MARK: - IApprovalService implementation
    /***********************************/
    /**
     * Method to retrieve all reports.
     */
    func getAllApprovals(_ completionHandler:( @escaping (Result<[Report]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Approval.getAllApprovals, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                var allReports: [Report] = []
                if let jsonReports = success[Constants.ResponseParameters.reports] as? [Any] {
                    for report in jsonReports {
                        allReports.append(Report(withJSON: JSON(report)))
                    }
                }
                completionHandler(Result.success(allReports))
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
}
