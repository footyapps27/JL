//
//  ApprovalListManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 16/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for ApprovalListViewController
 */
class ApprovalListManager {
    
    var approvalService: IApprovalService = ApprovalService()
    
    var approvals: [Report] = []
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ApprovalListManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getApprovals() -> [Report] {
        return approvals
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ApprovalListManager {
    /**
     * Method to get the title of the report.
     */
    func getReportTitle(forIndexPath indexPath: IndexPath) -> String {
        return approvals[indexPath.row].title
    }
    
    /**
     * Method to get the duration of the report.
     */
    func getReportDuration(forIndexPath indexPath: IndexPath) -> String {
        var duration = Constants.General.emptyString
        let report = approvals[indexPath.row]
        
        if let startDate = report.startDate {
            duration += Utilities.convertDateToStringForDisplay(startDate)
        }
        
        if let endDate = report.endDate {
            duration += " to " + Utilities.convertDateToStringForDisplay(endDate)
        }
        return duration
    }
    
    /**
     * Method to get the amount of the report.
     */
    func getFormattedReportAmount(forIndexPath indexPath: IndexPath) -> String {
        let report = approvals[indexPath.row]
        var currencyAndAmount = Constants.General.emptyString
        let baseCurrencyId = Singleton.sharedInstance.organization?.baseCurrencyId
        
        if let category = Singleton.sharedInstance.organization?.currencies[baseCurrencyId!] {
            currencyAndAmount = category.symbol
        }
        
        currencyAndAmount += " " + String(format: Constants.General.decimalFormat, report.amount)
        
        return currencyAndAmount
    }
    
    /**
     * Method to get the formatted status
     */
    func getReportStatus(forIndexPath indexPath: IndexPath) -> String {
        let report = approvals[indexPath.row]
        return Utilities.getStatus(forReport: report).capitalized
    }
}
/***********************************/
// MARK: - Service Calls
/***********************************/
extension ApprovalListManager {
    
    /**
     * Method to fetch all reports from the server.
     */
    func fetchApprovals(completionHandler: (@escaping (ManagerResponseToController<[Report]>) -> Void)) {
        approvalService.getAllApprovals({ [weak self] (result) in
            switch(result) {
            case .success(let approvalList):
                self?.approvals = approvalList
                completionHandler(ManagerResponseToController.success(approvalList))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
}
