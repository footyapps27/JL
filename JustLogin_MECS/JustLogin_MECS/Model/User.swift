//
//  User.swift
//  JustLogin_MECS
//
//  Created by Samrat on 6/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class User {
    var name: String = ""
    var role: Roles
    
    init(name: String, role:Roles) {
        self.name = name
        self.role = role
    }
}
