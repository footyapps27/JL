//
//  ReportDetailsManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class ReportDetailsManager {
    var report: Report = Report()
    
    var reportService: IReportService = ReportService()
}
/***********************************/
// MARK: - UI check value
/***********************************/
extension ReportDetailsManager {
    
    func isReportEditable() -> Bool {
        if report.status == ReportStatus.unsubmitted.rawValue ||
            report.status == ExpenseStatus.rejected.rawValue {
            return true
        }
        return false
    }
}
/***********************************/
// MARK: - TableView Audit history
/***********************************/
extension ReportDetailsManager {
    func getAuditHistories() -> [AuditHistory] {
        return report.auditHistory
    }
}
/***********************************/
// MARK: - TableView UI update
/***********************************/
extension ReportDetailsManager {
    func getAuditHistoryDescription(forIndexPath indexPath: IndexPath) -> String {
        return report.auditHistory[indexPath.row].description
    }
    
    func getAuditHistoryDetails(forIndexPath indexPath: IndexPath) -> String {
        let history = report.auditHistory[indexPath.row]
        if let date = history.date {
            return history.createdBy + " | " + Utilities.convertDateToStringForAuditHistoryDisplay(date)
        }
        return history.createdBy
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension ReportDetailsManager {
    /**
     * Method to fetch report details from the server.
     */
    func fetchReportDetails(withReportId reportId: String, completionHandler: (@escaping (ManagerResponseToController<Report>) -> Void)) {
        reportService.getReportDetails(reportId: reportId) { [weak self] (result) in
            switch(result) {
            case .success(let report):
                self?.report = report
                completionHandler(ManagerResponseToController.success(report))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        }
    }
}
