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
    
    /**
     * This will deal with submission/rejection of the report.
     */
    func processReport(payload: [String : Any], completionHandler:( @escaping (Result<Report>) -> Void))
}
/***********************************/
// MARK: - Properties
/***********************************/
struct ApprovalService {
    
    var serviceAdapter: NetworkAdapter = NetworkAdapterFactory.getNetworkAdapter()
}
/***********************************/
// MARK: - IApprovalService implementation
/***********************************/
extension ApprovalService: IApprovalService {
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
    
    func processReport(payload: [String : Any], completionHandler:( @escaping (Result<Report>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Approval.processReportApproval, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                let report = Report(withJSON: JSON(success))
                completionHandler(Result.success(report))
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
}
