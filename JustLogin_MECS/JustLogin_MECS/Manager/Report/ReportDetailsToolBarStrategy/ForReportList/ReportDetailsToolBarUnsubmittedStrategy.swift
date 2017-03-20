//
//  ReportDetailsToolBarUnsubmittedStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

struct ReportDetailsToolBarUnsubmittedStrategy: ReportDetailsToolBarBaseStrategy {
    
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let btnArchive = UIBarButtonItem(title: "Test", style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnArchive.tag = 1
        let btnViewAsPDF = UIBarButtonItem(title: "View", style: .plain, target: delegate, action: #selector(delegate.barButtonItemTapped(_:)))
        btnViewAsPDF.tag = 2
        
        toolBar.items = [flexibleSpace, btnArchive, flexibleSpace, btnViewAsPDF, flexibleSpace]
    }
    
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: ReportDetailsViewController) {
        
        let approversListViewController = UIStoryboard(name: Constants.StoryboardIds.reportStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIds.approversListViewController) as! ApproversListViewController
        approversListViewController.report = report
        //approversListViewController.delegate = controller
        // TODO - Create a utility function for this
        controller.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(approversListViewController, animated: true)
    }
}
