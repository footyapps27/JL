//
//  ReportListManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for ReportListViewController
 */
class ReportListManager {
    
    var reportService: IReportService = ReportService()
    
    var reports: [Report] = []
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ReportListManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getReports() -> [Report] {
        return reports
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ReportListManager {
    /**
     * Method to get the title of the report.
     */
    func getReportTitle(forIndexPath indexPath: IndexPath) -> String {
        return reports[indexPath.row].title
    }
    
    /**
     * Method to get the duration of the report.
     */
    func getReportDuration(forIndexPath indexPath: IndexPath) -> String {
        var duration = Constants.General.emptyString
        let report = reports[indexPath.row]
        
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
        let report = reports[indexPath.row]
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
        let report = reports[indexPath.row]
        return Utilities.getStatus(forReport: report).capitalized
    }
}
/***********************************/
// MARK: - Service Calls
/***********************************/
extension ReportListManager {

    /**
     * Method to fetch all reports from the server.
     */
    func fetchReports(completionHandler: (@escaping (ManagerResponseToController<[Report]>) -> Void)) {
        reportService.getAllReports({ [weak self] (result) in
            switch(result) {
            case .success(let reportList):
                self?.reports = reportList
                completionHandler(ManagerResponseToController.success(reportList))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
}
