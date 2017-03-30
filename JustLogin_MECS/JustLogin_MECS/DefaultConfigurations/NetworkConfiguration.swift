//
//  NetworkConfiguration.swift
//  JustLogin_MECS
//
//  Created by Samrat on 30/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct NetworkConfiguration {
    static func getNetworkAdapter() -> NetworkAdapter {
        return AlamofireNetworkAdapter()
    }
}
