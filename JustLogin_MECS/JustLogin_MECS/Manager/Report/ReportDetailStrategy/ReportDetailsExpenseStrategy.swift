//
//  ReportDetailsExpenseStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportDetailsExpenseStrategy {
    var report: Report?
}
/***********************************/
// MARK: - ReportDetailsStrategy
/***********************************/
extension ReportDetailsExpenseStrategy: ReportDetailsStrategy {
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> UITableViewCell {
        
        self.report = report
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.expenseListTableViewCellIdentifier, for: indexPath) as! ExpenseListTableViewCell
        
        cell.lblExpenseName.text = getCategoryName(forIndexPath: indexPath)
        cell.lblDateAndDescription.text = getDateAndDescription(forIndexPath: indexPath)
        cell.lblAmount.text = getFormattedAmount(forIndexPath: indexPath)
        cell.lblStatus.text = getExpenseStatus(forIndexPath: indexPath)
        cell.imgAttachment.image = UIImage(named: getAttachmentImage(forIndexPath: indexPath))
        cell.imgPolicyViolation.image = UIImage(named: getPolicyViolationImage(forIndexPath: indexPath))
        
        return cell
    }
    
    func getCellHeight(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> CGFloat {
        return CGFloat(Constants.CellHeight.expenseAuditHistoryCellHeight)
    }
    
    func getNumberOfRows(forReport report: Report) -> Int {
        return report.expenses.count
    }
}
/***********************************/
// MARK: - TableView Cell helpers
/***********************************/
extension ReportDetailsExpenseStrategy {
    /**
     * Method to get the category name for Id
     */
    func getCategoryName(forIndexPath indexPath: IndexPath) -> String {
        if report != nil {
            let expense = report!.expenses[indexPath.row]
            return Utilities.getCategoryName(forExpense: expense)
        }
        log.error("Report is nil in ReportDetailsExpenseStrategy")
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the formatted date & description for an expense.
     */
    func getDateAndDescription(forIndexPath indexPath: IndexPath) -> String {
        if report != nil {
            let expense = report!.expenses[indexPath.row]
            var dateAndDescription = Constants.General.emptyString
            
            if let date = expense.date {
                dateAndDescription = Utilities.convertDateToStringForDisplay(date)
            } else {
                log.error("Expense date is nil")
            }
            
            if !expense.merchantName.isEmpty {
                dateAndDescription += " | " + expense.merchantName
            }
            
            return dateAndDescription
        }
        log.error("Report is nil in ReportDetailsExpenseStrategy")
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the formatted amount (currency + amount)
     */
    func getFormattedAmount(forIndexPath indexPath: IndexPath) -> String {
        if report != nil {
            let expense = report!.expenses[indexPath.row]
            return Utilities.getFormattedAmount(forExpense: expense)
        }
        log.error("Report is nil in ReportDetailsExpenseStrategy")
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the formatted status
     */
    func getExpenseStatus(forIndexPath indexPath: IndexPath) -> String {
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the attachment image
     */
    func getAttachmentImage(forIndexPath indexPath: IndexPath) -> String {
        if report != nil {
            let expense = report!.expenses[indexPath.row]
            return expense.hasAttachment ? Constants.UIImageNames.attachmentActive : Constants.UIImageNames.attachmentDefault
        }
        log.error("Report is nil in ReportDetailsExpenseStrategy")
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the policy violation image
     */
    func getPolicyViolationImage(forIndexPath indexPath: IndexPath) -> String {
        if report != nil {
            let expense = report!.expenses[indexPath.row]
            return expense.hasPolicyViolation ? Constants.UIImageNames.policyViolationActive : Constants.UIImageNames.policyViolationDefault
        }
        log.error("Report is nil in ReportDetailsExpenseStrategy")
        return Constants.General.emptyString
    }
}
