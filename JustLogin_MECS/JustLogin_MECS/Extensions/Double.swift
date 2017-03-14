//
//  Double.swift
//  JustLogin_MECS
//
//  Created by Samrat on 11/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
