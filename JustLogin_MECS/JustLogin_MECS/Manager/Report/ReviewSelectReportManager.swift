//
//  ReviewSelectReportManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 11/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
/**
 * Manager for ReviewSelectReportViewController
 */
class ReviewSelectReportManager {
    
    var reportService: IReportService = ReportService()
    
    var reports: [Report] = []
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ReviewSelectReportManager {
    func getReports() -> [Report] {
        return reports
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ReviewSelectReportManager {
    
    func getReportTitle(forIndexPath indexPath: IndexPath) -> String {
        return reports[indexPath.row].title
    }
    
    func getReportAmount(forIndexPath indexPath: IndexPath) -> String {
        return Utilities.getFormattedAmount(forReport: reports[indexPath.row])
    }
    
    func getCellAccessoryType(forIndexPath indexPath: IndexPath, preSelectedReportId: String?) -> UITableViewCellAccessoryType {
        let report = reports[indexPath.row]
        if preSelectedReportId == report.id {
            return UITableViewCellAccessoryType.checkmark
        }
        return UITableViewCellAccessoryType.none
    }
}
/***********************************/
// MARK: - Service Calls
/***********************************/
extension ReviewSelectReportManager {
    /**
     * Method to fetch all report from the server.
     */
    func fetchReports(completionHandler: (@escaping (ManagerResponseToController<[Report]>) -> Void)) {
        reportService.getAllReports({ [weak self] (result) in
            switch(result) {
            case .success(let reportList):
                // Only reports whose status is not submitted will be considered.
                self?.reports = reportList
                self?.sortAndFilterReports()
                completionHandler(ManagerResponseToController.success(self?.reports ?? []))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReviewSelectReportManager {
    func sortReportsByTitle(_ reports: [Report]) -> [Report] {
        return reports.sorted(by: { $0.title.localizedCaseInsensitiveCompare($1.title) == ComparisonResult.orderedAscending })
    }
    
    func filterUnsubmittedAndRejectedReports(_ reports: [Report]) -> [Report] {
        return reports.filter({ (report) -> Bool in
            if report.status == ReportStatus.unsubmitted.rawValue ||
                report.status == ReportStatus.rejected.rawValue {
                return true
            }
            return false
        })
    }
    
    func sortAndFilterReports() {
        reports = filterUnsubmittedAndRejectedReports(reports)
        reports = sortReportsByTitle(reports)
    }
}
