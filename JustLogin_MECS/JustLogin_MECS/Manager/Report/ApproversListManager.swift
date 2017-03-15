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
     * Method to fetch all reports from the server.
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
}
