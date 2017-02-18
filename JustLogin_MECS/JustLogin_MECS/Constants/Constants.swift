//
//  Constants.swift
//  JustLogin_MECS
//
//  Created by Samrat on 5/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct Constants {
    
    struct CellIdentifiers {
        static let LaunchCollectionViewCellIdentifier = "launchCollectionCellIdentifier"
        static let ExpenseListTableViewCellIdentifier = "expenseListTableViewCellIdentifier"
        static let SettingsListTableViewCellIdentifier = "settingsListTableViewCellIdentifier"
        static let ReportListTableViewCellIdentifier = "reportListTableViewCellIdentifier"
        static let ApprovalListTableViewCellIdentifier = "approvalListTableViewCellIdentifier"
    }
    
    struct CellHeight {
        static let ReportListCellHeight = 68
        static let ApprovalListCellHeight = 68
        static let ExpenseListCellHeight = 90
    }
    
    struct StoryboardIds {
        static let DashboardStoryboard = "Dashboard"
        static let ApproverAndAdminDashboard = "approverAndAdminDashboard"
        static let SubmitterDashboard = "submitterDashboard"
    }
    
    struct Notifications {
        static let LoginSuccessful = "loginSuccessful"
    }
    
    /***********************************/
    // MARK: - Web service related constants
    /***********************************/
    struct URLs {
        static let BaseURL = "http://52.220.239.178/api"
        static let Login = URLs.BaseURL + "/authentication/login"
    }
    
    struct RequestParameters {
        
        struct Login {
            static let OrganizationName = "organizationName"
            static let MemberName = "memberName"
            static let Password = "password"
        }
        
    }
}
