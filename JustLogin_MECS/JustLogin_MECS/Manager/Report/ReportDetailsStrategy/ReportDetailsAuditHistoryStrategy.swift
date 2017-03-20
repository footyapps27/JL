//
//  ReportDetailsAuditHistoryStrategy.swift
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
struct ReportDetailsAuditHistoryStrategy: ReportDetailsBaseStrategy {
    
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.auditHistoryTableViewCellIdentifier, for: indexPath) as! AuditHistoryTableViewCell
        
        cell.lblDescription.text = getAuditHistoryDescription(forIndexPath: indexPath, report: report)
        cell.lblUserAndDate.text = getAuditHistoryDetails(forIndexPath: indexPath, report: report)
        
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
    func getAuditHistoryDescription(forIndexPath indexPath: IndexPath, report: Report) -> String {
        return report.auditHistory[indexPath.row].description
    }
    
    func getAuditHistoryDetails(forIndexPath indexPath: IndexPath, report: Report) -> String {
        let history = report.auditHistory[indexPath.row]
        if let date = history.date {
            return history.createdBy + " | " + Utilities.convertDateToStringForAuditHistoryDisplay(date)
        }
        return history.createdBy
    }
}
