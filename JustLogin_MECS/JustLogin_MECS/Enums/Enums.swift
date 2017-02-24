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
    case draft = 0, submitted, rejected, approved, reimbursed, undoReimburse
    
    var name: String {
        get { return String(describing: self) }
    }
}

enum ExpenseStatus : Int {
    
    case unreported = 0,
    unsubmitted = 1,
    submitted = 2,
    rejected = 3,
    approved = 4,
    reimbursed = 6 // The enums are mapped to the backend, thus 5 is missing since front end is not displaying this.
    
    var name: String {
        get { return String(describing: self) }
    }
}
