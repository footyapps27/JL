//
//  ReportDetailsMoreDetailStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class ReportDetailsMoreDetailStrategy {
    var report: Report?
}
/***********************************/
// MARK: - ReportDetailsStrategy
/***********************************/
extension ReportDetailsMoreDetailStrategy: ReportDetailsStrategy {
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> UITableViewCell {
        
        self.report = report
        return createCell(withTableView: tableView, atIndexPath: indexPath)
    }
    
    func getCellHeight(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> CGFloat {
        self.report = report
        return CGFloat(getFieldsToDisplay().count)
    }
    
    func getNumberOfRows(forReport report: Report) -> Int {
        return 1
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension ReportDetailsMoreDetailStrategy {
    
    func createCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> ReportDetailsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reportDetailsTableViewCellIdentifier, for: indexPath) as! ReportDetailsTableViewCell
        
        cell.updateView(withFields: getFieldsToDisplay())
        return cell
    }
    
    func getFieldsToDisplay() -> [String : String] {
        var fieldsToDisplay: [String : String] = [:]
        if report != nil {
            if !report!.businessPurpose.isEmpty {
                fieldsToDisplay[LocalizedString.businessPurpose] = report?.businessPurpose
            }
            
            for dict in report!.customFields {
                // TODO: - Add the custom fields here
                print(dict)
            }
        }
        return fieldsToDisplay
    }
}
