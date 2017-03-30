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
    
    var authenticationService: IAuthenticationService = ServiceFactory.getAuthenticationService()
}
/***********************************/
// MARK: - Data tracking methods
/***********************************/
extension SettingsListManager {
    /**
     * Method to get all the expenses that need to be displayed.
     */
    func getFields() -> [[SettingsOptions]] {
        // TODO: - Check the role here before sending
        return getFieldsForAdmin()
    }
    
    func getOrganizationName() -> String {
        if let name = Singleton.sharedInstance.organization?.name {
            return name
        }
        return Constants.General.emptyString
    }
    
    func getRole() -> String {
        if let role = Singleton.sharedInstance.member?.role?.name {
            return role
        }
        return Constants.General.emptyString
    }
    
    func getProfileImageUrl() -> URL? {
        if let member = Singleton.sharedInstance.member {
            return URL.init(string: member.profileImageUrl)
        }
        return URL.init(string: Constants.General.emptyString)
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
    
    fileprivate func getFieldsForAdmin() -> [[SettingsOptions]] {
        var fields = [
            [SettingsOptions.organizationProfile,SettingsOptions.users],
            [SettingsOptions.expenseCategories, SettingsOptions.currencies, SettingsOptions.expensePreferences, SettingsOptions.perDiemPreferences, SettingsOptions.reportPreferences, SettingsOptions.mileagePreferences, SettingsOptions.applicationPreferences]
        ]
        fields += getCommonFields()
        return fields
    }
    
    fileprivate func getFieldsForSubmitter() -> [[SettingsOptions]] {
        var fields =  [[SettingsOptions.applicationPreferences]]
        fields += getCommonFields()
        return fields
    }
    
    fileprivate func getCommonFields() -> [[SettingsOptions]] {
        return [
            [SettingsOptions.tipCalculator, SettingsOptions.currencyConverter],
            [SettingsOptions.rateOurApp, SettingsOptions.submitFeedback, SettingsOptions.aboutUs],
            [SettingsOptions.upgradeOrganization]
        ]
    }
}
