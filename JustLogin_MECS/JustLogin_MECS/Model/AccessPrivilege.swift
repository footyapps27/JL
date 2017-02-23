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
    
    var approveReport: Int = Constants.Defaults.AccessPrivilegeApproveReports
    
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
        
        if json[Constants.ResponseParameters.CreateAndSubmitReports].exists() {
            createAndSubmitReports = json[Constants.ResponseParameters.CreateAndSubmitReports].boolValue
        }
        
        if json[Constants.ResponseParameters.RecordEmployeeAdvance].exists() {
            recordEmployeeAdvance = json[Constants.ResponseParameters.RecordEmployeeAdvance].boolValue
        }
        
        if json[Constants.ResponseParameters.RecordEmployeeAdvanceForOthers].exists() {
            recordEmployeeAdvanceForOthers = json[Constants.ResponseParameters.RecordEmployeeAdvanceForOthers].boolValue
        }
        
        if json[Constants.ResponseParameters.PreventExpenseCreationForParentCategory].exists() {
            preventExpenseCreationForParentCategory = json[Constants.ResponseParameters.PreventExpenseCreationForParentCategory].boolValue
        }
        
        if json[Constants.ResponseParameters.ViewAllCompanyReports].exists() {
            viewAllCompanyReports = json[Constants.ResponseParameters.ViewAllCompanyReports].boolValue
        }
        
        if json[Constants.ResponseParameters.ApproveReport].exists() {
            approveReport = json[Constants.ResponseParameters.ApproveReport].intValue
        }
        
        if json[Constants.ResponseParameters.ApproveReportWithPolicyViolation].exists() {
            approveReportWithPolicyViolation = json[Constants.ResponseParameters.ApproveReportWithPolicyViolation].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifyExpenseInSubmittedReport].exists() {
            modifyExpenseInSubmittedReport = json[Constants.ResponseParameters.ModifyExpenseInSubmittedReport].boolValue
        }
        
        if json[Constants.ResponseParameters.ReimburseReport].exists() {
            reimburseReport = json[Constants.ResponseParameters.ReimburseReport].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsUsers].exists() {
            modifySettingsUsers = json[Constants.ResponseParameters.ModifySettingsUsers].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsPreferences].exists() {
            modifySettingsPreferences = json[Constants.ResponseParameters.ModifySettingsPreferences].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsExpenseCategories].exists() {
            modifySettingsExpenseCategories = json[Constants.ResponseParameters.ModifySettingsExpenseCategories].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsCustomers].exists() {
            modifySettingsCustomers = json[Constants.ResponseParameters.ModifySettingsCustomers].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsProjects].exists() {
            modifySettingsProjects = json[Constants.ResponseParameters.ModifySettingsProjects].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsMerchants].exists() {
            modifySettingsMerchants = json[Constants.ResponseParameters.ModifySettingsMerchants].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsCurrencies].exists() {
            modifySettingsCurrencies = json[Constants.ResponseParameters.ModifySettingsCurrencies].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsTaxes].exists() {
            modifySettingsTaxes = json[Constants.ResponseParameters.ModifySettingsTaxes].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsPaymentMode].exists() {
            modifySettingsPaymentMode = json[Constants.ResponseParameters.ModifySettingsPaymentMode].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsManageIntegrations].exists() {
            modifySettingsManageIntegrations = json[Constants.ResponseParameters.ModifySettingsManageIntegrations].boolValue
        }
        
        if json[Constants.ResponseParameters.ModifySettingsBilling].exists() {
            modifySettingsBilling = json[Constants.ResponseParameters.ModifySettingsBilling].boolValue
        }
    }
}
