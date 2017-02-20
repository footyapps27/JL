//
//  Utilities.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

class Utilities {
    
    /**
     * Method to convert server string to date.
     */
    static func convertServerStringToDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.ServerDateFormat
        return dateFormatter.date(from: string)!
    }
    
    /**
     * Method to convert date to string.
     */
    static func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.LocalDisplayDateFormat
        return dateFormatter.string(from: date)
    }
}
    
