//
//  ReportDetailsExpenseStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - ReportDetailsStrategy
/***********************************/
struct ReportDetailsExpenseStrategy: ReportDetailsStrategy {
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.expenseListTableViewCellIdentifier, for: indexPath) as! ExpenseListTableViewCell
        
        cell.lblExpenseName.text = getCategoryName(forIndexPath: indexPath, report: report)
        cell.lblDateAndDescription.text = getDateAndDescription(forIndexPath: indexPath, report: report)
        cell.lblAmount.text = getFormattedAmount(forIndexPath: indexPath, report: report)
        cell.lblStatus.text = getExpenseStatus(forIndexPath: indexPath, report: report)
        cell.imgAttachment.image = UIImage(named: getAttachmentImage(forIndexPath: indexPath, report: report))
        cell.imgPolicyViolation.image = UIImage(named: getPolicyViolationImage(forIndexPath: indexPath, report: report))
        
        return cell
    }
    
    func getCellHeight(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> CGFloat {
        return CGFloat(Constants.CellHeight.expenseListCellHeight)
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
    func getCategoryName(forIndexPath indexPath: IndexPath, report: Report) -> String {
        let expense = report.expenses[indexPath.row]
        return Utilities.getCategoryName(forExpense: expense)
    }
    
    /**
     * Method to get the formatted date & description for an expense.
     */
    func getDateAndDescription(forIndexPath indexPath: IndexPath, report: Report) -> String {
        let expense = report.expenses[indexPath.row]
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
    
    /**
     * Method to get the formatted amount (currency + amount)
     */
    func getFormattedAmount(forIndexPath indexPath: IndexPath, report: Report) -> String {
        let expense = report.expenses[indexPath.row]
        return Utilities.getFormattedAmount(forExpense: expense)
    }
    
    /**
     * Method to get the formatted status
     */
    func getExpenseStatus(forIndexPath indexPath: IndexPath, report: Report) -> String {
        return Constants.General.emptyString
    }
    
    /**
     * Method to get the attachment image
     */
    func getAttachmentImage(forIndexPath indexPath: IndexPath, report: Report) -> String {
        let expense = report.expenses[indexPath.row]
        return expense.hasAttachment ? Constants.UIImageNames.attachmentActive : Constants.UIImageNames.attachmentDefault
    }
    
    /**
     * Method to get the policy violation image
     */
    func getPolicyViolationImage(forIndexPath indexPath: IndexPath, report: Report) -> String {
        let expense = report.expenses[indexPath.row]
        return expense.hasPolicyViolation ? Constants.UIImageNames.policyViolationActive : Constants.UIImageNames.policyViolationDefault
    }
    
}
