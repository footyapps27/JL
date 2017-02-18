//
//  Singleton.swift
//  JustLogin_MECS
//
//  Created by Samrat on 18/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

final class Singleton {
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    private init() { }
    
    static let sharedInstance: Singleton = Singleton()
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    var accessTokenHeader: [String:String] = [:]
}
