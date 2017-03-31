//
//  ServiceFactory.swift
//  JustLogin_MECS
//
//  Created by Samrat on 30/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 The factory class for various service protocols.
 */
struct ServiceFactory {
    /**
     Get the concrete object that is implementing IAuthenticationService.
     
     - Returns: A new instance of an object implementing IAuthenticationService.
     */
    static func getAuthenticationService() -> IAuthenticationService {
        return AuthenticationService()
    }
    
    /**
     Get the concrete object that is implementing IAuthenticationService.
     
     - Returns: A new instance of an object implementing IAuthenticationService.
     */
    static func getOrganizationDetailsService() -> IOrganizationDetailsService {
        return OrganizationDetailsService()
    }
    
    /**
     Get the concrete object that is implementing IExpenseService.
     
     - Returns: A new instance of an object implementing IExpenseService.
     */
    static func getExpenseService() -> IExpenseService {
        return ExpenseService()
    }
    
    /**
     Get the concrete object that is implementing IReportService.
     
     - Returns: A new instance of an object implementing IReportService.
     */
    static func getReportService() -> IReportService {
        return ReportService()
    }
    
    /**
     Get the concrete object that is implementing ICategoryService.
     
     - Returns: A new instance of an object implementing ICategoryService.
     */
    static func getCategoryService() -> ICategoryService {
        return CategoryService()
    }
    
    /**
     Get the concrete object that is implementing ICurrencyService.
     
     - Returns: A new instance of an object implementing ICurrencyService.
     */
    static func getCurrencyService() -> ICurrencyService {
        return CurrencyService()
    }
    
    /**
     Get the concrete object that is implementing IApprovalService.
     
     - Returns: A new instance of an object implementing IApprovalService.
     */
    static func getApprovalService() -> IApprovalService {
        return ApprovalService()
    }
    
    /**
     Get the concrete object that is implementing IMemberService.
     
     - Returns: A new instance of an object implementing IMemberService.
     */
    static func getMemberService() -> IMemberService {
        return MemberService()
    }
}
