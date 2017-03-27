//
//  HomeScreenManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for HomeViewController
 */
class HomeScreenManager {
}
/***********************************/
// MARK: - UI update
/***********************************/
extension HomeScreenManager {
    
    func getMemberName() -> String {
        if let member = Singleton.sharedInstance.member {
            return "Hi" + " " + member.fullName + ","
        }
        return "Hi,"
    }
    
    func getDashboardIdentifier() -> String {
        var identifier = Constants.StoryboardIds.Dashboard.submitterDashboard
        
        guard let accessPrivileges = Singleton.sharedInstance.member?.role?.accessPrivileges else {
            log.error("Access Privileges found nil when unwrapping")
            return identifier
        }
        
        if accessPrivileges.approveReport > 0 {
            identifier = Constants.StoryboardIds.Dashboard.approverAndAdminDashboard
        }
        
        return identifier
    }
}
