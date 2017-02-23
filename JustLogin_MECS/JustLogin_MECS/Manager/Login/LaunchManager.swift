//
//  SignInManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 19/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for SignInViewController
 */
class LaunchManager {
    
    var loginService: ILoginService = LoginService()
    var organizationDetailsService: IOrganizationDetailsService = OrganizationDetailsService()
    
    struct LaunchContent {
        var imageName: String!
        var description: String!
    }
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    /**
     Method to set the content that will be displayed in the collection view.
     */
    func getLaunchContent() -> [LaunchContent] {
        // TODO: - Put these in the constants file.
        return [LaunchContent(imageName:"", description:"Effortlessly Expense Reporting."),
                LaunchContent(imageName:"", description:"Automatically extract data from receipts."),
                LaunchContent(imageName:"", description:"Know everything about your expense."),
                LaunchContent(imageName:"", description:"Track mileage with your phone.")]
    }
    
    /**
     *
     */
    func navigateToApprovalFlow() throws -> Bool {
        
        guard let accessPrivileges = Singleton.sharedInstance.member?.role?.accessPrivileges else {
            log.error("Access Privileges found nil when unwrapping")
            throw CustomError.accessPrivilegesNotFound
        }
        return accessPrivileges.approveReport > 0
    }
}
