//
//  ReportDetailsManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 27/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportDetailsManager {
    var report: Report = Report()
    
    var reportService: IReportService = ReportService()
    
    var segmentedControlSelectedIndex: Int = ReportDetailSegmentedControl.expenses.rawValue
}
/***********************************/
// MARK: - Data tracking
/***********************************/
extension ReportDetailsManager {
    
    func getSelectedSegmentedControlIndex() -> Int {
        return segmentedControlSelectedIndex
    }
    
    func setSelectedSegmentedControlIndex(_ index: Int) {
        segmentedControlSelectedIndex = index
    }
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
    
    func shouldDisplayFooter() -> Bool {
         return segmentedControlSelectedIndex == ReportDetailSegmentedControl.expenses.rawValue
    }
    
    func shouldHaveSeparator() -> Bool {
        return segmentedControlSelectedIndex != ReportDetailSegmentedControl.moreDetails.rawValue
    }
}
/***********************************/
// MARK: - TableView Datasource
/***********************************/
extension ReportDetailsManager {
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let strategy = getStrategy(forSelectedSegmentIndex: segmentedControlSelectedIndex)
        return strategy.getCell(withTableView: tableView, atIndexPath: indexPath, forReport: report)
    }
    
    func getHeightForRowAt(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> CGFloat {
        let strategy = getStrategy(forSelectedSegmentIndex: segmentedControlSelectedIndex)
        return strategy.getCellHeight(withTableView: tableView, atIndexPath: indexPath, forReport: report)
    }
    
    func getNumberOfRows() -> Int {
        let strategy = getStrategy(forSelectedSegmentIndex: segmentedControlSelectedIndex)
        return strategy.getNumberOfRows(forReport: report)
    }
}
/***********************************/
// MARK: - Tableview Header & Footer
/***********************************/
extension ReportDetailsManager {
    
    func getReportTitle() -> String {
        return report.title
    }
    
    func getReportAmount() -> String {
        return Utilities.getFormattedAmount(forReport: report)
    }
    
    func getReportStatus() -> String {
        return Utilities.getStatus(forReport: report).uppercased()
    }
    
    func getReportDuration() -> String {
        var duration = Constants.General.emptyString
        
        if let date = report.startDate {
            duration = Utilities.convertDateToStringForDisplay(date)
        } else {
            log.error("Report Start date is nil")
        }
        
        if let date = report.endDate {
            duration += " - " + Utilities.convertDateToStringForDisplay(date)
        } else {
            log.error("Report end date is nil")
        }
        
        return duration
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
/***********************************/
// MARK: - Strategy Selector
/***********************************/
extension ReportDetailsManager {
    func getStrategy(forSelectedSegmentIndex selectedIndex: Int) -> ReportDetailsStrategy {
        switch selectedIndex {
        case ReportDetailSegmentedControl.expenses.rawValue:
            return ReportDetailsExpenseStrategy()
        case ReportDetailSegmentedControl.moreDetails.rawValue:
            return ReportDetailsMoreDetailStrategy()
        case ReportDetailSegmentedControl.history.rawValue:
            fallthrough
        default:
            return ReportDetailsAuditHistoryStrategy()
        }
    }
}
