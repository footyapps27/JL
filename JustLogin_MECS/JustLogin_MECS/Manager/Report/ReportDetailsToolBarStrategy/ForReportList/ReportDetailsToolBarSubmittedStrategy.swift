//
//  ReportDetailsToolBarSubmittedStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - ReportDetailsToolBarBaseStrategy
/***********************************/
struct ReportDetailsToolBarSubmittedStrategy: ReportDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnRecall = UIBarButtonItem(title: LocalizedString.recall, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnRecall.tag = ReportDetailsToolBarButtonTag.left.rawValue
        
        let btnViewAsPDF = UIBarButtonItem(title: LocalizedString.viewAsPDF, style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewAsPDF.tag = ReportDetailsToolBarButtonTag.right.rawValue
        
        toolBar.items = [flexibleSpace, btnRecall, flexibleSpace, btnViewAsPDF, flexibleSpace]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: ReportDetailsViewController) {
        switch(barButton.tag) {
        case ReportDetailsToolBarButtonTag.left.rawValue:
            recallReport(report, onController: controller)
        case ReportDetailsToolBarButtonTag.right.rawValue:
            viewAsPDF(forReport: report, onController: controller)
        default:
            log.debug("Default")
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension ReportDetailsToolBarSubmittedStrategy {
    /**
     * Recall report.
     */
    func recallReport(_ report: Report, onController controller: ReportDetailsViewController) {
        // TODO - Here we first call the process report, & then ask the screen to refresh.
    }
    
    /**
     * Display the list of options for the user as an action sheet.
     */
    func viewAsPDF(forReport report: Report, onController controller: ReportDetailsViewController) {
        // TODO - Part of phase 2.
    }
}
