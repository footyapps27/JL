//
//  ReportDetailsStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 14/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

protocol ReportDetailsStrategy {
    func getCell(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> UITableViewCell
    
    func getCellHeight(withTableView tableView: UITableView, atIndexPath indexPath: IndexPath, forReport report: Report) -> CGFloat
    
    func getNumberOfRows(forReport report: Report) -> Int
}
