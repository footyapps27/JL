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
        static let dateFormatReceivedFromServer = "yyyy-MM-dd'T'HH:mm:ss"
        static let dateFormatReceivedFromServerForAuditHistory = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        static let localDisplayDateFormat = "dd/MM/yyyy"
        static let auditHistoryDisplayDateFormat = "dd/MM/yyyy hh:mm a"
        static let dateFormatSentToServer = "yyyy-MM-dd"
        static let decimalFormat = "%.2f"
    }
    
    struct UISize {
        static let activityIndicatorHeightWidth = 50
        static let expenseHeaderViewIntialHeight = 250
    }
    
    struct ViewControllerTitles {
        static let reviewSelectCategory = "Select a Category"
        static let reviewSelectCurrency = "Select a Currency"
        static let reviewSelectReport = "Select a Report"
        static let reviewSelectExpenses = "Select Expenses"
        static let addExpense = "Add Expense"
        
        static let settings = "Settings"
        static let expenses = "Expenses"
        static let reports = "Reports"
        static let approvals = "Approvals"
        static let reimbursement = "Reimbursement"
    }
    
    struct UIImageNames {
        static let attachmentActive = "AttachmentActive"
        static let attachmentDefault = "AttachmentDefault"
        static let policyViolationActive = "PolicyViolationActive"
        static let policyViolationDefault = "PolicyViolationDefault"
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
        static let fieldType = 0
        static let categoryImage = "Category8"
    }
    
    struct CellIdentifiers {
        static let defaultTableViewCellIdentifier = "defaultTableViewCellIdentifier"
        
        static let launchCollectionViewCellIdentifier = "launchCollectionCellIdentifier"
        static let expenseListTableViewCellIdentifier = "expenseListTableViewCellIdentifier"
        static let settingsListTableViewCellIdentifier = "settingsListTableViewCellIdentifier"
        static let reportListTableViewCellIdentifier = "reportListTableViewCellIdentifier"
        static let approvalListTableViewCellIdentifier = "approvalListTableViewCellIdentifier"
        
        static let customFieldTableViewCellWithTextFieldIdentifier = "customFieldTableViewCellWithTextFieldIdentifier"
        static let customFieldTableViewCellWithMultipleSelectionIdentifier = "customFieldTableViewCellWithMultipleSelectionIdentifier"
        static let customFieldTableViewCellWithTextViewIdentifier = "customFieldTableViewCellWithTextViewIdentifier"
        static let customFieldTableViewCellDurationIdentifier = "customFieldTableViewCellDurationIdentifier"
        
        static let customFieldTableViewCellCategoryIdentifier = "customFieldTableViewCellCategoryIdentifier"
        static let customFieldTableViewCellDateIdentifier = "customFieldTableViewCellDateIdentifier"
        static let customFieldTableViewCellCurrencyAndAmountIdentifier = "customFieldTableViewCellCurrencyAndAmountIdentifier"
        static let customFieldTableViewCellWithImageSelectionIdentifier = "customFieldTableViewCellWithImageSelectionIdentifier"
        
        
        static let auditHistoryTableViewCellIdentifier = "auditHistoryTableViewCellIdentifier"
        
        static let reviewSelectCategoryTableViewCellIdentifier = "reviewSelectCategoryTableViewCellIdentifier"
        static let reviewSelectReportTableViewCellIdentifier = "reviewSelectReportTableViewCellIdentifier"
        
        static let customFieldTableViewCellWithLabelIdentifier = "customFieldTableViewCellWithLabelIdentifier"
        
        static let reportDetailsTableViewCellIdentifier = "reportDetailsTableViewCellIdentifier"
        static let approversListTableViewCellIdentifier = "approversListTableViewCellIdentifier"
    }
    
    struct CellHeight {
        static let reportListCellHeight = 68
        static let approvalListCellHeight = 68
        static let expenseListCellHeight = 90
        static let expenseAuditHistoryCellHeight = 47
        static let reportMoreDetailsCellHeight = 62
    }
    
    struct StoryboardIds {
        static let dashboardStoryboard = "Dashboard"
        static let expenseStoryboard = "Expense"
        static let reportStoryboard = "Report"
        static let mainStoryboard = "Main"
        static let categoryStoryboard = "Category"
        static let currencyStoryboard = "Currency"
        static let approvalStoryboard = "Approval"
        
        static let approverAndAdminDashboard = "approverAndAdminDashboard"
        static let submitterDashboard = "submitterDashboard"
        
        static let addExpenseViewController = "addExpenseViewController"
        static let expenseDetailsViewController = "expenseDetailsViewController"
        static let addReportViewController = "addReportViewController"
        static let approversListViewController = "approversListViewController"
        static let reportDetailsViewController = "reportDetailsViewController"
        static let launchViewController = "launchViewController"
        static let recordReimbursementViewController = "recordReimbursementViewController"
        
        static let reviewSelectCategoryViewController = "reviewSelectCategoryViewController"
        static let reviewSelectCurrencyViewController = "reviewSelectCurrencyViewController"
        static let reviewSelectReportViewController = "reviewSelectReportViewController"
    }
    
    struct Notifications {
        static let loginSuccessful = "loginSuccessful"
        static let refreshReportList = "refreshReportList"
        static let refreshExpenseList = "refreshExpenseList"
        static let refreshReportDetails = "refreshReportDetails"
        static let refreshApprovalList = "refreshApprovalList"
    }
    
    /***********************************/
    // MARK: - Web service related constants
    /***********************************/
    
    /***********************************/
    // MARK: - URLs
    /***********************************/
    struct URLs {
        static let baseURL = "http://52.220.239.178/api"
        
        struct Authentication {
            static let login = URLs.baseURL + "/authentication/login"
            static let logout = URLs.baseURL + "/authentication/logout"
        }
        
        struct Organization {
            static let organizationDetails = URLs.baseURL + "/organization/details"
        }
        
        struct Expense {
            static let getAllExpenses = URLs.baseURL + "/expense/retrievebymember"
            static let expenseDetails = URLs.baseURL + "/expense/retrieve"
            static let createExpense = URLs.baseURL + "/expense/create"
            static let updateExpense = URLs.baseURL + "/expense/update"
            static let deleteExpense = URLs.baseURL + "/expense/delete"
        }
        
        struct Report {
            static let getAllReports = URLs.baseURL + "/report/retrievebymember"
            static let reportDetails = URLs.baseURL + "/report/retrieve"
            static let createReport = URLs.baseURL + "/report/create"
            static let updateReport = URLs.baseURL + "/report/update"
            static let deleteReport = URLs.baseURL + "/report/delete"
        }
        
        struct Category {
            static let getAllCategories = URLs.baseURL + "/category/retrievebyorganization"
            static let createCategory = URLs.baseURL + "/category/create"
            static let updateCategory = URLs.baseURL + "/category/update"
            static let deleteCategory = URLs.baseURL + "/category/delete"
        }
        
        struct Currency {
            static let getAllCurrencies = URLs.baseURL + "/currency/retrievebyorganization"
            static let createCurrency = URLs.baseURL + "/currency/create"
            static let updateCurrency = URLs.baseURL + "/currency/update"
            static let deleteCurrency = URLs.baseURL + "/currency/delete"
        }
        
        struct Approval { // TODO - rename this
            static let getAllApprovals = URLs.baseURL + "/approval/retrievebyapprover"
            static let processReportApproval = URLs.baseURL + "/approval/process"
        }
        
        struct Member {
            static let getApprovers = URLs.baseURL + "/member/retrieveallapprovers"
        }
    }
    
    /***********************************/
    // MARK: - Request Parameters
    /***********************************/
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
        
        struct Report {
            static let reportId = "reportId"
            static let businessPurpose = "businessPurpose"
            static let title = "title"
            static let startDate = "startDate"
            static let endDate = "endDate"
            static let statusType = "statusType"
            static let submittedToId = "submittedToId"
            static let reason = "reason"
        }
    }
    
    /***********************************/
    // MARK: - Response Parameters
    /***********************************/
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
        static let profileImageUrl = "profileImageUrl"
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
        
        static let dataType = "dataType"
        static let fieldName = "fieldName"
        static let isEnabled = "isEnabled"
        static let isMandatory = "isMandatory"
        static let expenseCustomFields = "expenseCustomFields"
        static let reportCustomFields = "reportCustomFields"
        
        static let project = "project"
        static let customer = "customer"
        
        static let expenses = "expenses"
        static let expenseId = "expenseId"
        static let date = "date"
        static let hasAttachment = "hasAttachment"
        static let hasPolicyViolation = "hasPolicyViolation"
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
        static let reportNumber = "reportNumber"
        static let businessPurpose = "businessPurpose"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let title = "title"
        static let expenseIds = "expenseIds"
        
        static let reason = "reason"
        static let createdDate = "createdDate"
        static let createdBy = "createdBy"
        static let history = "history"
        
        static let members = "members"
        
        static let submitter = "submitter"
        static let approver = "approver"
        static let reimburse = "reimburse"
        static let submittedTo = "submittedTo"
    }
}
