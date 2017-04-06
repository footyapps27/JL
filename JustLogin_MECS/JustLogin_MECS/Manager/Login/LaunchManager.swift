//
//  SignInManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 19/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for LaunchViewController
 */
class LaunchManager {
    
    var authenticationService:IAuthenticationService = ServiceFactory.getAuthenticationService()
    var organizationDetailsService: IOrganizationDetailsService = ServiceFactory.getOrganizationDetailsService()
    
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
    func navigateToApprovalFlow(_ completionHandler: ((ManagerResponseToController<Bool>) -> Void)) {
        
        guard let accessPrivileges = Singleton.sharedInstance.member?.role?.accessPrivileges else {
            log.error("Access Privileges found nil when unwrapping")
            // TODO: - Move to constants
            completionHandler(ManagerResponseToController.failure(code: "", message: "Something went wrong. Please try again."))
            return
        }
        
        accessPrivileges.approveReport > 0
            ? completionHandler(ManagerResponseToController.success(true))
            : completionHandler(ManagerResponseToController.success(false))
    }
}
