//
//  BaseManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 22/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * This will be used by the manager to send the response to the view controller.
 */
enum ManagerResponseToController<T> {
    case success(T)
    case failure(code: String,message: String)
}

enum CustomError: Error {
    case memberNotFound
    case accessPrivilegesNotFound
}
