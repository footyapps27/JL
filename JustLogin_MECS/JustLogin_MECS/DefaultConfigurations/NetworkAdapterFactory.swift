//
//  NetworkAdapterFactory.swift
//  JustLogin_MECS
//
//  Created by Samrat on 30/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 The factory class for network adapter.
 */
struct NetworkAdapterFactory {
    /**
     Get the concrete object that is implementing NetworkAdapter.
     
     - Returns: A new instance of an object implementing NetworkAdapter.
     */
    static func getNetworkAdapter() -> NetworkAdapter {
        return AlamofireNetworkAdapter()
    }
}
