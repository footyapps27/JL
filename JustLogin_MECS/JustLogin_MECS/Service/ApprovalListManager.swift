//
//  ApprovalListManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 16/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
    Manager for ApprovalListViewController.
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
        Get the report approvals that is attached to this user.
     
        - Returns: List of report approvals for the current logged in user.
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
     Get the report title at a particular indexpath.
     The row property of the indexPath will be taken into account & checked against the list of approvals.
     
     - Parameter indexPath: The indexPath against which the report title is required.
     
     - Returns: The title of the report at the particular indexPath.row from the approval list.
     */
    func getReportTitle(forIndexPath indexPath: IndexPath) -> String {
        return approvals[indexPath.row].title
    }
    
    /**
     Get the report duration at a particular indexpath.
     The row property of the indexPath will be taken into account & checked against the list of approvals.
     
     - Parameter indexPath: The indexPath against which the report title is required.
     
     - Returns: The duration of the report at the particular indexPath.row from the approval list. This will format the start & end date as desired. e.g. 10/10/2017 to 12/12/2017
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
     Get the formatted report amount at a particular indexpath.
     The row property of the indexPath will be taken into account & checked against the list of approvals.
     
     - Parameter indexPath: The indexPath against which the report title is required.
     
     - Returns: The formatted amount of the report at the particular indexPath.row from the approval list. This will format the amount, adding the currency code attached to the report. e.g. S$ 50.47
     */
    func getFormattedReportAmount(forIndexPath indexPath: IndexPath) -> String {
        let report = approvals[indexPath.row]
        var currencyAndAmount = Constants.General.emptyString
        let baseCurrencyId = Singleton.sharedInstance.organization?.baseCurrencyId
        
        if let currency = Singleton.sharedInstance.organization?.currencies[baseCurrencyId!] {
            currencyAndAmount = currency.symbol
        }
        
        currencyAndAmount += " " + String(format: Constants.General.decimalFormat, report.amount)
        
        return currencyAndAmount
    }
    
    /**
     Get the submitter name who has submitted the report for approval at a particular indexpath.
     The row property of the indexPath will be taken into account & checked against the list of approvals.
     
     - Parameter indexPath: The indexPath against which the report title is required.
     
     - Returns: The submitter who has submitted the report for approval.
     */
    func getSubmitterName(forIndexPath indexPath: IndexPath) -> String {
        let report = approvals[indexPath.row]
        return report.submitter.name
    }
    
    /**
     Get the status of the report at a particular indexpath.
     The row property of the indexPath will be taken into account & checked against the list of approvals.
     
     - Parameter indexPath: The indexPath against which the report title is required.
     
     - Returns: A string stating the current status of the report.
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
     Retrieve list of approvals for this user from the server.
     
     - Parameter completionHandler: Escaping closure which will return either Success or Failure. 
     Success response: List of report approvals for the user.
     Failure response: Code & message if something went wrong while retrieving the list of approvals.
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
