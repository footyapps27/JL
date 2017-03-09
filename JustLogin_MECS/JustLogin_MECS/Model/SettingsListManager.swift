//
//  SettingsListManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 9/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
/**
 * Manager for ReportListViewController
 */
class SettingsListManager {
    
    var authenticationService: IAuthenticationService = AuthenticationService()
    
    var reports: [Report] = []
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension SettingsListManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getReports() -> [Report] {
        return reports
    }
}
/***********************************/
// MARK: - Service Call
/***********************************/
extension SettingsListManager {
    /**
     * Method to fetch all reports from the server.
     */
    func signOut(completionHandler: (@escaping (ManagerResponseToController<Void>) -> Void)) {
        authenticationService.logoutUser { (result) in
            switch(result) {
            case .success():
                // Clear out the singleton
                Singleton.sharedInstance.flushSharedInstance()
                completionHandler(ManagerResponseToController.success())
            case .error(let serviceError):
                completionHandler(ManagerResponseToController.failure(code: serviceError.code, message: serviceError.message))
            case .failure(let message):
                completionHandler(ManagerResponseToController.failure(code: "", message: message)) // TODO: - Pass a general code
            }
        }
    }
}
/***********************************/
// MARK: - Data manipulation
/***********************************/
extension SettingsListManager {
    
    func updateFieldsForAdmin() {
    }
    
    func updateFieldsForSubmitter() {
        
    }
}
