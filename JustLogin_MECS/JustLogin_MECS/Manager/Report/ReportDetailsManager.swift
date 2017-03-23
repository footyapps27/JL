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
    
    var approvalService: IApprovalService = ApprovalService()
    
    var segmentedControlSelectedIndex: Int = ReportDetailsSegmentedControl.expenses.rawValue
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
    func shouldDisplayFooter() -> Bool {
         return segmentedControlSelectedIndex == ReportDetailsSegmentedControl.expenses.rawValue
    }
    
    func shouldHaveSeparator() -> Bool {
        return segmentedControlSelectedIndex != ReportDetailsSegmentedControl.moreDetails.rawValue
    }
    
    func updateToolBar(_ toolBar: UIToolbar, caller: ReportDetailsCaller, delegate: ReportDetailsToolBarActionDelegate) {
        let strategy = getToolBarStrategy(forReportStatus: ReportStatus(rawValue: report.status)!, caller: caller)
        strategy.formatToolBar(toolBar, withDelegate: delegate)
    }
}
/***********************************/
// MARK: - Actions
/***********************************/
extension ReportDetailsManager {
    /**
     * Action for the toolbar items.
     */
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, caller: ReportDetailsCaller, onController controller: BaseViewController) {
        let strategy = getToolBarStrategy(forReportStatus: ReportStatus(rawValue: report.status)!, caller: caller)
        strategy.performActionForBarButtonItem(barButton, forReport: report, onController: controller)
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
    
    /**
     * Method to update the status of a report. 
     * The report that is sent, needs to provide the updated status.
     */
    func processReport(withPayload payload: [String : Any], completionHandler: (@escaping (ManagerResponseToController<Report>) -> Void)) {
        approvalService.processReport(payload: payload, completionHandler: { (result) in
            switch(result) {
            case .success(let finalReport):
                completionHandler(ManagerResponseToController.success(finalReport))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
}
/***********************************/
// MARK: - Segment Strategy Selector
/***********************************/
extension ReportDetailsManager {
    func getStrategy(forSelectedSegmentIndex selectedIndex: Int) -> ReportDetailsBaseStrategy {
        switch selectedIndex {
        case ReportDetailsSegmentedControl.expenses.rawValue:
            return ReportDetailsExpenseStrategy()
        case ReportDetailsSegmentedControl.moreDetails.rawValue:
            return ReportDetailsMoreDetailStrategy()
        case ReportDetailsSegmentedControl.history.rawValue:
            fallthrough
        default:
            return ReportDetailsAuditHistoryStrategy()
        }
    }
}
/***********************************/
// MARK: - Toolbar Strategy Selector
/***********************************/
extension ReportDetailsManager {
    func getToolBarStrategy(forReportStatus status: ReportStatus, caller: ReportDetailsCaller) -> ReportDetailsToolBarBaseStrategy {
        var strategy: ReportDetailsToolBarBaseStrategy
        switch(status, caller) {
        case (ReportStatus.unsubmitted, ReportDetailsCaller.reportList):
            strategy = ReportDetailsToolBarUnsubmittedStrategy()
            
        case (ReportStatus.submitted, ReportDetailsCaller.reportList):
            strategy = ReportDetailsToolBarSubmittedStrategy()
            
        case (ReportStatus.approved, ReportDetailsCaller.reportList): fallthrough
        case (ReportStatus.reimbursed, ReportDetailsCaller.reportList):
            strategy = ReportDetailsToolBarApprovedAndReimbursedStrategy()
        
        case (ReportStatus.submitted, ReportDetailsCaller.approvalList):
            strategy = ReportDetailsToolBarApprovalListSubmittedStrategy()
            
        case (ReportStatus.approved, ReportDetailsCaller.approvalList):
            strategy = ReportDetailsToolBarApprovalListApprovedStrategy()
            
        case (ReportStatus.reimbursed, ReportDetailsCaller.approvalList):
            strategy = ReportDetailsToolBarApprovalListReimbursedStrategy()
        default:
            strategy = ReportDetailsToolBarUnsubmittedStrategy()
        }
        return strategy
    }
}
