//
//  ReportDetailsAuditHistoryStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportDetailsAuditHistoryStrategy {
    var report: Report?
}
/***********************************/
// MARK: - ReportDetailsStrategy
/***********************************/
extension ReportDetailsAuditHistoryStrategy: ReportDetailsStrategy {
    
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> UITableViewCell {
        
        self.report = report
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.auditHistoryTableViewCellIdentifier, for: indexPath) as! AuditHistoryTableViewCell
        
        cell.lblDescription.text = getAuditHistoryDescription(forIndexPath: indexPath)
        cell.lblUserAndDate.text = getAuditHistoryDetails(forIndexPath: indexPath)
        
        return cell
    }
    
    func getCellHeight(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> CGFloat {
        return CGFloat(Constants.CellHeight.expenseAuditHistoryCellHeight)
    }
    
    func getNumberOfRows(forReport report: Report) -> Int {
        return report.auditHistory.count
    }
}
/***********************************/
// MARK: - Cell Update
/***********************************/
extension ReportDetailsAuditHistoryStrategy {
    func getAuditHistoryDescription(forIndexPath indexPath: IndexPath) -> String {
        if report != nil {
            return report!.auditHistory[indexPath.row].description
        }
        log.error("Report is nil in ReportDetailsAuditHistoryStrategy")
        return Constants.General.emptyString
    }
    
    func getAuditHistoryDetails(forIndexPath indexPath: IndexPath) -> String {
        if report != nil {
            let history = report!.auditHistory[indexPath.row]
            if let date = history.date {
                return history.createdBy + " | " + Utilities.convertDateToStringForAuditHistoryDisplay(date)
            }
            return history.createdBy
        }
        log.error("Report is nil in ReportDetailsAuditHistoryStrategy")
        return Constants.General.emptyString
    }
}
