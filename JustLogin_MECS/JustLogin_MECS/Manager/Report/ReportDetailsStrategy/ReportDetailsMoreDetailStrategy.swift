//
//  ReportDetailsMoreDetailStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - ReportDetailsBaseStrategy
/***********************************/
struct ReportDetailsMoreDetailStrategy: ReportDetailsBaseStrategy {
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reportDetailsTableViewCellIdentifier, for: indexPath) as! ReportDetailsTableViewCell
        
        let dict = getFieldsToDisplay(forReport: report)[indexPath.row]
        
        cell.updateView(withFieldName: dict.keys.first!, fieldValue: dict.values.first!)
        return cell
    }
    
    func getCellHeight(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> CGFloat {
        return CGFloat(Constants.CellHeight.reportMoreDetailsCellHeight)
    }
    
    func getNumberOfRows(forReport report: Report) -> Int {
        return getFieldsToDisplay(forReport: report).count
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension ReportDetailsMoreDetailStrategy {
    func getFieldsToDisplay(forReport report: Report) -> [[String : String]] {
        var fieldsToDisplay: [[String : String]] = []
        
        if !report.reportNumber.isEmpty {
            let dict = [LocalizedString.reportNumber : report.reportNumber]
            fieldsToDisplay.append(dict)
        }
        
        let dict = [LocalizedString.reportDuration : getDuration(forReport: report)]
        fieldsToDisplay.append(dict)
        
        if !report.businessPurpose.isEmpty {
            let dict = [LocalizedString.businessPurpose : report.businessPurpose]
            fieldsToDisplay.append(dict)
        }
        
        for dict in report.customFields {
            // TODO: - Add the custom fields here
            log.debug(dict)
        }
        return fieldsToDisplay
    }
    
    func getDuration(forReport report: Report) -> String {
        var duration = Constants.General.emptyString
        
        if let date = report.startDate {
            duration = Utilities.convertDateToStringForDisplay(date)
        } else {
            log.error("Report Start date is nil")
        }
        
        if let date = report.endDate {
            duration += " - " + Utilities.convertDateToStringForDisplay(date)
        } else {
            log.error("Report end date is nil")
        }
        
        return duration
    }
}
