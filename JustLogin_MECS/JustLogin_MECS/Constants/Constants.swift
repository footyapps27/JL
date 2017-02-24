//
//  Constants.swift
//  JustLogin_MECS
//
//  Created by Samrat on 5/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct Constants {
    
    struct General {
        static let emptyString = ""
        static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        static let localDisplayDateFormat = "dd/MM/yyyy"
        static let decimalFormat = "%.2f"
    }
    
    struct Defaults {
        static let numberOfSections = 1
        static let decimalPlaces = 2
        static let amount = 0.00
        static let ExpenseStatus = 0
        static let reportStatus = 0
        static let categoryLogo = 0
        static let accessPrivilegeApproveReports = 0
        static let exchangeRate = 1.0
    }
    
    struct CellIdentifiers {
        static let launchCollectionViewCellIdentifier = "launchCollectionCellIdentifier"
        static let expenseListTableViewCellIdentifier = "expenseListTableViewCellIdentifier"
        static let settingsListTableViewCellIdentifier = "settingsListTableViewCellIdentifier"
        static let reportListTableViewCellIdentifier = "reportListTableViewCellIdentifier"
        static let approvalListTableViewCellIdentifier = "approvalListTableViewCellIdentifier"
    }
    
    struct CellHeight {
        static let reportListCellHeight = 68
        static let approvalListCellHeight = 68
        static let expenseListCellHeight = 90
    }
    
    struct StoryboardIds {
        static let dashboardStoryboard = "Dashboard"
        static let expenseStoryboard = "Expense"
        static let approverAndAdminDashboard = "approverAndAdminDashboard"
        static let submitterDashboard = "submitterDashboard"
        static let addExpenseViewController = "addExpenseViewController"
        static let expenseDetailsViewController = "expenseDetailsViewController"
    }
    
    struct Notifications {
        static let loginSuccessful = "loginSuccessful"
    }
    
    /***********************************/
    // MARK: - Web service related constants
    /***********************************/
    struct URLs {
        static let baseURL = "http://52.220.239.178/api"
        
        static let login = URLs.baseURL + "/authentication/login"
        static let logout = URLs.baseURL + "/authentication/logout"
        
        static let organizationDetails = URLs.baseURL + "/organization/details"
        
        static let getAllExpenses = URLs.baseURL + "/expense/retrievebymember"
        static let createExpense = URLs.baseURL + "/expense/create"
        static let updateExpense = URLs.baseURL + "/expense/update"
        static let deleteExpense = URLs.baseURL + "/expense/delete"
        
        static let getAllReports = URLs.baseURL + "/report/retrievebymember"
        static let createReport = URLs.baseURL + "/organization/details"
        static let updateReport = URLs.baseURL + "/organization/details"
        static let deleteReport = URLs.baseURL + "/organization/details"
    }
    
    struct RequestParameters {
        struct General {
            static let ids = "ids"
        }
        
        struct Login {
            static let organizationName = "organizationName"
            static let memberName = "memberName"
            static let password = "password"
        }
        
        struct Expense {
            static let expenseId = "expenseId"
            static let categoryId = "categoryId"
            static let currencyId = "currencyId"
            static let reportId = "reportId"
            static let date = "date"
            static let amount = "amount"
            static let exchange = "exchange"
            static let status = "status"
            static let paymentMode = "paymentMode"
            static let description = "description"
            static let location = "location"
            static let referenceNumber = "referenceNumber"
            static let notes = "notes"
        }
    }
    
    struct ResponseParameters {
        static let accessToken = "AccessToken"
        
        static let statusCode = 200
        static let data = "data"
        
        static let errors = "errors"
        static let errorCode = "errorCode"
        static let errorMessage = "errorMessage"
        
        static let memberId = "memberId"
        static let userId = "userId"
        static let fullName = "fullName"
        static let status = "status"
        static let organizationId = "organizationId"
        static let role = "role"
        
        static let roleId = "roleId"
        static let name = "name"
        static let description = "description"
        static let isDefault = "isDefault"
        static let accessPrivileges = "accessPrivileges"
        
        static let baseCurrencyId = "baseCurrencyId"
        static let currencies = "currencies"
        static let categories = "categories"
        
        static let categoryId = "categoryId"
        static let logo = "logo"
        static let accountCode = "accountCode"
        static let isActive = "isActive"
        
        static let currencyId = "currencyId"
        static let decimalPlaces = "decimalPlaces"
        static let format = "format"
        static let symbol = "symbol"
        static let code = "code"
        
        static let createAndSubmitReports = "createAndSubmitReports"
        static let recordEmployeeAdvance = "recordEmployeeAdvance"
        static let recordEmployeeAdvanceForOthers = "recordEmployeeAdvanceForOthers"
        static let preventExpenseCreationForParentCategory = "preventExpenseCreationForParentCategory"
        static let viewAllCompanyReports = "viewAllCompanyReports"
        static let approveReport = "approveReport"
        static let approveReportWithPolicyViolation = "approveReportWithPolicyViolation"
        static let modifyExpenseInSubmittedReport = "modifyExpenseInSubmittedReport"
        static let reimburseReport = "reimburseReport"
        static let modifySettingsUsers = "users"
        static let modifySettingsPreferences = "preferences"
        static let modifySettingsExpenseCategories = "expenseCategories"
        static let modifySettingsCustomers = "customers"
        static let modifySettingsProjects = "projects"
        static let modifySettingsMerchants = "merchants"
        static let modifySettingsCurrencies = "currencies"
        static let modifySettingsTaxes = "taxes"
        static let modifySettingsPaymentMode = "paymentMode"
        static let modifySettingsManageIntegrations = "manageIntegrations"
        static let modifySettingsBilling = "billing"
        
        static let expenses = "expenses"
        static let expenseId = "expenseId"
        static let date = "date"
        static let amount = "amount"
        static let exchange = "exchange"
        static let location = "location"
        static let referenceNumber = "referenceNumber"
        static let notes = "notes"
        static let merchantName = "merchantName"
        static let paymentMode = "paymentMode"
        static let submitterId = "submitterId"
        
        static let reports = "reports"
        static let reportId = "reportId"
        static let businessPurpose = "businessPurpose"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let title = "title"
        static let expenseIds = "expenseIds"
    }
}
