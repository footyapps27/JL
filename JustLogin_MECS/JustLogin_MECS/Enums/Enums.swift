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
    dropdown
}
