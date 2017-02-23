//
//  AccessPrivilege.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AccessPrivilege {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    var createAndSubmitReports: Bool = false
    
    var recordEmployeeAdvance: Bool = false
    
    var recordEmployeeAdvanceForOthers: Bool = false
    
    var preventExpenseCreationForParentCategory: Bool = false
    
    var viewAllCompanyReports: Bool = false
    
    var approveReport: Int = Constants.Defaults.accessPrivilegeApproveReports
    
    var approveReportWithPolicyViolation: Bool = false
    
    var modifyExpenseInSubmittedReport: Bool = false
    
    var reimburseReport: Bool = false
    
    var modifySettingsUsers: Bool = false
    
    var modifySettingsPreferences: Bool = false
    
    var modifySettingsExpenseCategories: Bool = false
    
    var modifySettingsCustomers: Bool = false
    
    var modifySettingsProjects: Bool = false
    
    var modifySettingsMerchants: Bool = false
    
    var modifySettingsCurrencies: Bool = false
    
    var modifySettingsTaxes: Bool = false
    
    var modifySettingsPaymentMode: Bool = false
    
    var modifySettingsManageIntegrations: Bool = false
    
    var modifySettingsBilling: Bool = false
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    
    /**
     * Default initializer
     */
    init() {
        
    }
    
    /**
     * Initialize using the JSON object received from the server.
     */
    init(withJSON json:JSON) {
        
        createAndSubmitReports = json[Constants.ResponseParameters.createAndSubmitReports].boolValue
        
        recordEmployeeAdvance = json[Constants.ResponseParameters.recordEmployeeAdvance].boolValue
        
        recordEmployeeAdvanceForOthers = json[Constants.ResponseParameters.recordEmployeeAdvanceForOthers].boolValue
        
        preventExpenseCreationForParentCategory = json[Constants.ResponseParameters.preventExpenseCreationForParentCategory].boolValue
        
        viewAllCompanyReports = json[Constants.ResponseParameters.viewAllCompanyReports].boolValue
        
        approveReport = json[Constants.ResponseParameters.approveReport].intValue
        
        approveReportWithPolicyViolation = json[Constants.ResponseParameters.approveReportWithPolicyViolation].boolValue
        
        modifyExpenseInSubmittedReport = json[Constants.ResponseParameters.modifyExpenseInSubmittedReport].boolValue
        
        reimburseReport = json[Constants.ResponseParameters.reimburseReport].boolValue
        
        modifySettingsUsers = json[Constants.ResponseParameters.modifySettingsUsers].boolValue
        
        modifySettingsPreferences = json[Constants.ResponseParameters.modifySettingsPreferences].boolValue
        
        modifySettingsExpenseCategories = json[Constants.ResponseParameters.modifySettingsExpenseCategories].boolValue
        
        modifySettingsCustomers = json[Constants.ResponseParameters.modifySettingsCustomers].boolValue
        
        modifySettingsProjects = json[Constants.ResponseParameters.modifySettingsProjects].boolValue
        
        modifySettingsMerchants = json[Constants.ResponseParameters.modifySettingsMerchants].boolValue
        
        
        modifySettingsCurrencies = json[Constants.ResponseParameters.modifySettingsCurrencies].boolValue
        
        
        modifySettingsTaxes = json[Constants.ResponseParameters.modifySettingsTaxes].boolValue
        
        modifySettingsPaymentMode = json[Constants.ResponseParameters.modifySettingsPaymentMode].boolValue
        
        modifySettingsManageIntegrations = json[Constants.ResponseParameters.modifySettingsManageIntegrations].boolValue
        
        modifySettingsBilling = json[Constants.ResponseParameters.modifySettingsBilling].boolValue
    }
}
