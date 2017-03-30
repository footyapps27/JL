//
//  ServiceConfiguration.swift
//  JustLogin_MECS
//
//  Created by Samrat on 30/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct ServiceConfiguration {
    
    static func getAuthenticationService() -> IAuthenticationService {
        return AuthenticationService()
    }
    
    static func getOrganizationDetailsService() -> IOrganizationDetailsService {
        return OrganizationDetailsService()
    }
    
    static func getExpenseService() -> IExpenseService {
        return ExpenseService()
    }
    
    static func getReportService() -> IReportService {
        return ReportService()
    }
    
    static func getCategoryService() -> ICategoryService {
        return CategoryService()
    }
    
    static func getCurrencyService() -> ICurrencyService {
        return CurrencyService()
    }
    
    static func getApprovalService() -> IApprovalService {
        return ApprovalService()
    }
    
    static func getMemberService() -> IMemberService {
        return MemberService()
    }
}
