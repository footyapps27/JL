//
//  Roles.swift
//  JustLogin_MECS
//
//  Created by Samrat on 6/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Roles
/***********************************/
enum Roles {
    case Submitter, Approver, Admin
}

/***********************************/
// MARK: - Report Status
/***********************************/
enum ReportStatus : Int
{
    case recalled = -1, unsubmitted, submitted, rejected, approved, reimbursed, undoReimburse
    
    var name: String {
        get { return String(describing: self) }
    }
}

/***********************************/
// MARK: - Expense Status
/***********************************/
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

/***********************************/
// MARK: - Expense & Report Field Types
/***********************************/
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

/***********************************/
// MARK: - Settings Options
/***********************************/
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
/***********************************/
// MARK: - Report Details Segment Control
/***********************************/
enum ReportDetailsSegmentedControl: Int {
    case expenses = 0,
    moreDetails,
    history
}
/***********************************/
// MARK: - Report Details Caller
/***********************************/
enum ReportDetailsCaller: Int {
    case reportList = 0,
    approvalList
}
/***********************************/
// MARK: - Bar Button Tags for Report Details
/***********************************/
enum ReportDetailsToolBarButtonTag: Int {
    case left = 0,
    middle,
    right
}
/***********************************/
// MARK: - Color
/***********************************/
enum Color {
    
    case theme
    case background
    case required
    case tabBarText
    
    // For custom colors
    case custom(hexString: String, alpha: Double)
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .theme:
            instanceColor = UIColor(hexString: "#0098AA")
        case .background:
            instanceColor = UIColor(hexString: "#F1F3F6")
        case .required:
            instanceColor = UIColor(hexString: "#E44864")
        case .tabBarText:
            instanceColor = UIColor(hexString: "#7B7B7B")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}
