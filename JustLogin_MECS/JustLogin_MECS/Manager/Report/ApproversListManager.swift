//
//  ApproversListManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 15/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for ReportListViewController
 */
class ApproversListManager {
    
    var reportService: IReportService = ReportService()
    
    var memberService: IMemberService = MemberService()
    
    var approvers: [Member] = []
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension ApproversListManager {
    /**
     * Method to get all the approvers that need to be displayed.
     */
    func getApprovers() -> [Member] {
        return approvers
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ApproversListManager {
    /**
     * Method to get the title of the report.
     */
    func getMemberProfileImage(forIndexPath indexPath: IndexPath) -> String {
        return "" // TODO - Implement the same
    }
    
    /**
     * Method to get the duration of the report.
     */
    func getMemberName(forIndexPath indexPath: IndexPath) -> String {
        let member = approvers[indexPath.row]
        return member.fullName
    }
}
/***********************************/
// MARK: - Service Calls
/***********************************/
extension ApproversListManager {
    
    /**
     * Method to fetch all approvers from the server.
     */
    func fetchApprovers(completionHandler: (@escaping (ManagerResponseToController<[Member]>) -> Void)) {
        memberService.getApproversForCurrentUser({ [weak self] (result) in
            switch(result) {
            case .success(let approverList):
                self?.approvers = approverList
                completionHandler(ManagerResponseToController.success(approverList))
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        })
    }
    
    /**
     * Method to process a report.
     */
    func processReport(_ report: Report, withApprover approver: Member, completionHandler: (@escaping (ManagerResponseToController<Report>) -> Void)) {
        // Step 1: - Update report with the member id.
        
        var updatedReport = report
        updatedReport.submittedTo.id = approver.id
        
        reportService.update(report: updatedReport) { [weak self] (result) in
            switch(result) {
            case .success(let receivedReport):
                // Step 2: - Submit the report with the updated status.
                
                var statusUpdatedReport = receivedReport
                statusUpdatedReport.status = ReportStatus.submitted.rawValue
                
                self?.reportService.processReport(report: statusUpdatedReport, completionHandler: { (processReportResult) in
                    
                    switch(result) {
                    case .success(let finalReport):
                        completionHandler(ManagerResponseToController.success(finalReport))
                    case .error(let serviceError):
                        completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
                    case .failure(let message):
                        completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
                    }
                })
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        }
    }
}
