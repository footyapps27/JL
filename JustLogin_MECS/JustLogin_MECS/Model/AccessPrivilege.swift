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
    
    let createAndSubmitReports: Bool
    
    let recordEmployeeAdvance: Bool
    
    let recordEmployeeAdvanceForOthers: Bool
    
    let preventExpenseCreationForParentCategory: Bool
    
    let viewAllCompanyReports: Bool
    
    let approveReport: Int
    
    let approveReportWithPolicyViolation: Bool
    
    let modifyExpenseInSubmittedReport: Bool
    
    let reimburseReport: Bool
    
    let modifySettingsUsers: Bool
    
    let modifySettingsPreferences: Bool
    
    let modifySettingsExpenseCategories: Bool
    
    let modifySettingsCustomers: Bool
    
    let modifySettingsProjects: Bool
    
    let modifySettingsMerchants: Bool
    
    let modifySettingsCurrencies: Bool
    
    let modifySettingsTaxes: Bool
    
    let modifySettingsPaymentMode: Bool
    
    let modifySettingsManageIntegrations: Bool
    
    let modifySettingsBilling: Bool
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    init(_ json:JSON) {
        createAndSubmitReports = json["createAndSubmitReports"].exists() ? json["createAndSubmitReports"].boolValue : false
        
        recordEmployeeAdvance = json["recordEmployeeAdvance"].exists() ? json["recordEmployeeAdvance"].boolValue : false
        
        recordEmployeeAdvanceForOthers = json["recordEmployeeAdvanceForOthers"].exists() ? json["recordEmployeeAdvanceForOthers"].boolValue : false
        
        preventExpenseCreationForParentCategory = json["preventExpenseCreationForParentCategory"].exists() ? json["preventExpenseCreationForParentCategory"].boolValue : false
        
        viewAllCompanyReports = json["viewAllCompanyReports"].exists() ? json["viewAllCompanyReports"].boolValue : false
        
        approveReport = json["approveReport"].exists() ? json["approveReport"].intValue : 0
        
        approveReportWithPolicyViolation = json["approveReportWithPolicyViolation"].exists() ? json["approveReportWithPolicyViolation"].boolValue : false
        
        modifyExpenseInSubmittedReport = json["modifyExpenseInSubmittedReport"].exists() ? json["modifyExpenseInSubmittedReport"].boolValue : false
        
        reimburseReport = json["reimburseReport"].exists() ? json["reimburseReport"].boolValue : false
        
        modifySettingsUsers = json["users"].exists() ? json["users"].boolValue : false
        
        modifySettingsPreferences = json["preferences"].exists() ? json["preferences"].boolValue : false
        
        modifySettingsExpenseCategories = json["expenseCategories"].exists() ? json["expenseCategories"].boolValue : false
        
        modifySettingsCustomers = json["customers"].exists() ? json["customers"].boolValue : false
        
        modifySettingsProjects = json["projects"].exists() ? json["projects"].boolValue : false
        
        modifySettingsMerchants = json["merchants"].exists() ? json["merchants"].boolValue : false
        
        modifySettingsCurrencies = json["currencies"].exists() ? json["currencies"].boolValue : false
        
        modifySettingsTaxes = json["taxes"].exists() ? json["taxes"].boolValue : false
        
        modifySettingsPaymentMode = json["paymentMode"].exists() ? json["paymentMode"].boolValue : false
        
        modifySettingsManageIntegrations = json["manageIntegrations"].exists() ? json["manageIntegrations"].boolValue : false
        
        modifySettingsBilling = json["billing"].exists() ? json["billing"].boolValue : false
    }
}
