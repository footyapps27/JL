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
    }
    
    struct StoryboardIds {
        static let DashboardStoryboard = "Dashboard"
        static let ApproverAndAdminDashboard = "approverAndAdminDashboard"
        static let SubmitterDashboard = "submitterDashboard"
    }
    
    struct Notifications {
        static let LoginSuccessful = "loginSuccessful"
    }
}
