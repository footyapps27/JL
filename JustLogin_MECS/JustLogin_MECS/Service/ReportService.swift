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
     * Method to retrieve details of an expense.
     */
    func getReportDetails(reportId: String, completionHandler:( @escaping (Result<Report>) -> Void))
    
    /**
     * Create a new report.
     */
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Report>) -> Void))
    
    /**
     * Update an existing report.
     */
    func update(report: Report, completionHandler:( @escaping (Result<Report>) -> Void))
    
    /**
     * Update an existing report from payload.
     */
    func update(payload: [String : Any], completionHandler:( @escaping (Result<Report>) -> Void))
    
    /**
     * Delete an existing report.
     */
    func delete(reportId: String, completionHandler:( @escaping (Result<Report>) -> Void))
    
    /**
     * Link multiple expenses to a report.
     */
    func linkExpenseIds(_ expenseIds: [String], toReport report: Report, completionHandler:( @escaping (Result<Void>) -> Void))
    
    /**
     Unlink an expense from the report it is attached to.
     
     - Parameter expense: The expense which needs to be unlinked.
     - Parameter completionHandler: Escaping closure which will return either Success or Failure.
     Success response: An empty response.
     Failure response: Code & message if something went wrong while retrieving the list of approvals.
     
     */
    func unlinkExpenseFromAttachedReport(_ expense: Expense, completionHandler:( @escaping (Result<Void>) -> Void))
}
/***********************************/
// MARK: - IExpenseService implementation
/***********************************/
struct ReportService : IReportService {
    
    var serviceAdapter: NetworkAdapter = NetworkAdapterFactory.getNetworkAdapter()
    
    /**
     * Method to retrieve all reports.
     */
    func getAllReports(_ completionHandler:( @escaping (Result<[Report]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Report.getAllReports, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
    
    func getReportDetails(reportId: String, completionHandler:( @escaping (Result<Report>) -> Void)) {
        let payload = getPayloadForReportDetails(reportId)
        serviceAdapter.post(destination: Constants.URLs.Report.reportDetails
        , payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
    
    /**
     * Create a new report.
     */
    func create(payload: [String : Any], completionHandler:( @escaping (Result<Report>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Report.createReport, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
    
    /**
     * Update an existing report.
     */
    func update(report: Report, completionHandler:( @escaping (Result<Report>) -> Void)) {
        let payload = getPayloadForUpdateReport(report)
        return update(payload: payload, completionHandler: completionHandler)
    }
    
    /**
     * Update an existing report.
     */
    func update(payload: [String : Any], completionHandler:( @escaping (Result<Report>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Report.updateReport, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
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
    
    /**
     * Delete an existing report.
     */
    func delete(reportId: String, completionHandler:( @escaping (Result<Report>) -> Void)) {
        let payload = getPayloadForDeleteReport(reportId)
        serviceAdapter.post(destination: Constants.URLs.Report.deleteReport, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            // TODO: - Need to handle the scenarios here.
        }
    }
    
    func linkExpenseIds(_ expenseIds: [String], toReport report: Report, completionHandler:( @escaping (Result<Void>) -> Void)) {
        let payload = getPayloadForLinkingExpenses(expenseIds, toReport: report)
        serviceAdapter.post(destination: Constants.URLs.Report.linkExpensesToReport, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(_ , _):
                completionHandler(Result.success())
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func unlinkExpenseFromAttachedReport(_ expense: Expense, completionHandler:( @escaping (Result<Void>) -> Void)) {
        let payload = getPayloadForUnlinkingExpense(expense)
        serviceAdapter.post(destination: Constants.URLs.Report.unlinkExpenseFromReport, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(_ , _):
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
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportService {
    
    /**
     * Method to format payload for expense details.
     */
    func getPayloadForReportDetails(_ reportId: String) -> [String : Any] {
        return [Constants.RequestParameters.General.ids : [reportId]]
    }
    
    /**
     * Method to format payload for update report.
     */
    func getPayloadForUpdateReport(_ report: Report) -> [String : Any] {
        var payload: [String : Any] = [:]
        
        if !report.title.isEmpty {
            payload[Constants.RequestParameters.Report.title] = report.title
        }
        
        if !report.id.isEmpty {
            payload[Constants.RequestParameters.Report.reportId] = report.id
        }
        
        if !report.businessPurpose.isEmpty {
            payload[Constants.RequestParameters.Report.businessPurpose] = report.businessPurpose
        }
        
        if !report.submittedTo.id.isEmpty {
            payload[Constants.RequestParameters.Report.submittedToId] = report.submittedTo.id
        }
        
        if let startDate = report.startDate {
            payload[Constants.RequestParameters.Report.startDate] = Utilities.convertDateToStringForServerCommunication(startDate)
        }
        
        if let endDate = report.endDate {
            payload[Constants.RequestParameters.Report.endDate] = Utilities.convertDateToStringForServerCommunication(endDate)
        }
        
        payload[Constants.RequestParameters.Report.statusType] = report.status
        
        return payload
    }
    
    /**
     * Method to format payload for delete report.
     */
    func getPayloadForDeleteReport(_ reportId: String) -> [String : String] {
        // TODO: - Need to handle the scenarios here.
        return [:]
    }
    
    /**
     * Method to format payload for linking expenses to a report.
     */
    func getPayloadForLinkingExpenses(_ expenseIds: [String], toReport report: Report) -> [String : Any] {
        var payload: [String : Any] = [:]
        payload[Constants.RequestParameters.Expense.expenseIds] =  expenseIds
        payload[Constants.RequestParameters.Expense.reportId] = report.id
        return payload
    }
    
    func getPayloadForUnlinkingExpense(_ expense: Expense) -> [String : Any] {
        var payload: [String : Any] = [:]
        payload[Constants.RequestParameters.Expense.expenseIds] =  [expense.id]
        payload[Constants.RequestParameters.Report.reportId] = expense.reportId
        return payload
    }
}
