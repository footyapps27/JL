//
//  ReportService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IReportService {
    
    /**
     * Method to retrieve all reports.
     */
    func getAllReports(_ completionHandler:( @escaping (Result<[Report]>) -> Void))
    
    /**
     * Create a new report.
     */
    func create(report: Report, completionHandler:( @escaping (Result<Report>) -> Void))
    
    /**
     * Update an existing report.
     */
    func update(report: Report, completionHandler:( @escaping (Result<Report>) -> Void))
    
    /**
     * Delete an existing report.
     */
    func delete(reportId: String, completionHandler:( @escaping (Result<Report>) -> Void))
    
}

struct ReportService : IReportService {
    
    var serviceAdapter: NetworkAdapter = AlamofireNetworkAdapter()
    
    /***********************************/
    // MARK: - IExpenseService implementation
    /***********************************/
    
    /**
     * Method to retrieve all reports.
     */
    func getAllReports(_ completionHandler:( @escaping (Result<[Report]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.getAllReports, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
    
    /**
     * Create a new report.
     */
    func create(report: Report, completionHandler:( @escaping (Result<Report>) -> Void)) {
        let payload = getPayloadForCreateReport(report)
        serviceAdapter.post(destination: Constants.URLs.createExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
        }
    }
    
    /**
     * Update an existing report.
     */
    func update(report: Report, completionHandler:( @escaping (Result<Report>) -> Void)) {
        let payload = getPayloadForUpdateReport(report)
        serviceAdapter.post(destination: Constants.URLs.createExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
        }
    }
    
    /**
     * Delete an existing report.
     */
    func delete(reportId: String, completionHandler:( @escaping (Result<Report>) -> Void)) {
        let payload = getPayloadForDeleteReport(reportId)
        serviceAdapter.post(destination: Constants.URLs.createExpense, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
        }
    }

}

extension ReportService {
    
    /**
     * Method to format payload for create report.
     */
    func getPayloadForCreateReport(_ report: Report) -> [String : String] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
    
    /**
     * Method to format payload for update report.
     */
    func getPayloadForUpdateReport(_ report: Report) -> [String : String] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
    
    /**
     * Method to format payload for delete report.
     */
    func getPayloadForDeleteReport(_ reportId: String) -> [String : String] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
}
