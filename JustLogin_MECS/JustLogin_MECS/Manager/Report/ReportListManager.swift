//
//  ReportListManager.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Manager for ReportListViewController
 */
struct ReportListManager {
    
    var reportService: IReportService = ReportService()
    
    /***********************************/
    // MARK: - Public Methods
    /***********************************/
    
    func getAllReports(complimentionHandler: (@escaping (Result<[Report]>) -> Void)) {
        reportService.getAllReports({ (reports) in
            log.debug(reports)
        })
    }
    
    
}
