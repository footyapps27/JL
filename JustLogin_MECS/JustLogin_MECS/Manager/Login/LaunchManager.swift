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
struct LaunchManager {
    
    var loginService: ILoginService = LoginService()
    var organizationDetailsService: IOrganizationDetailsService = OrganizationDetailsService()
    
    struct LaunchContent {
        var imageName: String!
        var description: String!
    }
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    func login(withOrganizationName organizationName: String, userId: String, password: String, completionHandler:( @escaping (Result<Member>) -> Void)) {
        loginService.loginUser(withOrganizationName: organizationName, userId: userId, password: password, completionHandler: completionHandler)
    }
    
    func getOrganizationDetails(complimentionHandler: (@escaping (Result<Organization>) -> Void)) {
        organizationDetailsService.getOrganizationDetails(complimentionHandler)
    }
    
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
}
