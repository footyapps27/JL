//
//  Roles.swift
//  JustLogin_MECS
//
//  Created by Samrat on 6/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

enum Roles {
    case Submitter, Approver, Admin
}

enum ReportStatus : Int
{
    case unsubmitted = 0, submitted, rejected, approved, reimbursed, undoReimburse
    
    var name: String {
        get { return String(describing: self) }
    }
}

enum ExpenseStatus : Int {
    
    case unreported = -1,
    unsubmitted,
    submitted,
    rejected,
    approved,
    reimbursed
    
    var name: String {
        get { return String(describing: self) }
    }
}

enum ExpenseAndReportFieldType: Int {
    case text = 0,
    email,
    url,
    phone,
    number,
    decimal,
    amount,
    percent,
    date,
    checkBox,
    doubleTextField,
    textView,
    dropdown,
    category,
    currencyAndAmount,
    imageSelection
}

enum SettingsOptions: String {
    case organizationProfile = "Organization Profile"
    case users = "Users"
    case expenseCategories = "Expense Categories"
    case currencies = "Currencies"
    case expensePreferences = "Expense Preferences"
    case perDiemPreferences = "Per Diem Preferences"
    case reportPreferences = "Report Preferences"
    case mileagePreferences = "Mileage Preferences"
    case applicationPreferences = "Application Preferences"
    case tipCalculator = "Tip Calculator"
    case currencyConverter = "Currency Converter"
    case rateOurApp = "Rate our app"
    case submitFeedback = "Submit Feedback"
    case aboutUs = "About Us"
    case upgradeOrganization = "Upgrade Organization"
}

enum ReportDetailSegmentedControl: Int {
    case expenses = 0,
    moreDetails,
    history
}
