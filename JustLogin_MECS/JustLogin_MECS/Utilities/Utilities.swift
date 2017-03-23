//
//  Utilities.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import SnapKit

/***********************************/
// MARK: - String to date conversion
/***********************************/
class Utilities {
    /**
     * Method to convert server string to date.
     */
    static func convertServerStringToDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.dateFormatReceivedFromServer
        return dateFormatter.date(from: string)
    }
    
    /**
     * Method to convert server string to date for history.
     */
    static func convertAuditHistoryServerStringToDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.dateFormatReceivedFromServerForAuditHistory
        return dateFormatter.date(from: string)
    }
    
    /**
     * Method to convert date to string.
     */
    static func convertDateToStringForDisplay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.localDisplayDateFormat
        return dateFormatter.string(from: date)
    }
    
    static func convertDateToStringForAuditHistoryDisplay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.auditHistoryDisplayDateFormat
        return dateFormatter.string(from: date)
    }
    
    static func convertDateToStringForServerCommunication(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.dateFormatSentToServer
        return dateFormatter.string(from: date)
    }
    
}
/***********************************/
// MARK: - Show alerts
/***********************************/
extension Utilities {
    /**
     * Method to show an error alert.
     */
    static func showErrorAlert(withMessage message: String, onController controller: UIViewController) {
        // TODO: - Add to the text file.
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        controller.present(alert, animated: true)
    }
    
    /**
     * Method to show an success alert.
     */
    static func showSuccessAlert(withMessage message: String, onController controller: UIViewController) {
        // TODO: - Add to the text file.
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        controller.present(alert, animated: true)
    }

    /**
     * Method to show an action sheet.
     */
    static func showActionSheet(withTitle title: String?, message: String?, actions: [UIAlertAction], onController controller: UIViewController) {
        let actionsheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionCancel = UIAlertAction(title: LocalizedString.cancel, style: .cancel) { void in
            actionsheet.dismiss(animated: true, completion: nil)
        }
        actionsheet.addAction(actionCancel)
        
        for action in actions {
            actionsheet.addAction(action)
        }
        
        controller.present(actionsheet, animated: true, completion: nil)
    }
}
/***********************************/
// MARK: - Network
/***********************************/
extension Utilities {
    /**
     * Check if connection is available.
     */
    static func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
/***********************************/
// MARK: - Dynamic UI creation
/***********************************/
extension Utilities {
    static func getDynamicView(withFieldName fieldName: String, andFieldValue fieldValue: String) -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: - Put the values in constant
        let lblFieldName = UILabel()
        lblFieldName.text = fieldName
        lblFieldName.font = UIFont.systemFont(ofSize: 14)
        
        let lblFieldValue = UILabel()
        lblFieldValue.text = fieldValue
        lblFieldValue.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(lblFieldName)
        view.addSubview(lblFieldValue)
        
        lblFieldName.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view).offset(-8)
            make.height.equalTo(25)
        }
        
        lblFieldValue.snp.makeConstraints { (make) in
            make.top.equalTo(lblFieldName.snp.bottom).offset(-2)
            make.left.equalTo(view)
            make.right.equalTo(view).offset(-8)
            make.height.equalTo(25)
        }
        return view
    }
}
/***********************************/
// MARK: - UI update
/***********************************/
extension Utilities {
    /**
     * Method to adjust the inset of a scroll view when the keyboard is displayed or hidden.
     */
    static func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification, scrollView: UIScrollView) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
}
/***********************************/
// MARK: - UI update
/***********************************/
extension Utilities {
    /**
     * Method to push a controller & hide the tab bar.
     * When returning back the tab bar will again be shown.
     */
    static func pushControllerAndHideTabbarForChildOnly(fromController: UIViewController, toController: UIViewController) {
      pushControllerAndHideTabbarForChildAndParent(fromController: fromController, toController: toController)
        fromController.hidesBottomBarWhenPushed = false
    }
    
    /**
     * Method to push a controller & hide the tab bar.
     * When returning back the tab bar will NOT be shown.
     */
    static func pushControllerAndHideTabbarForChildAndParent(fromController: UIViewController, toController: UIViewController) {
        fromController.hidesBottomBarWhenPushed = true
        fromController.navigationController?.pushViewController(toController, animated: true)
    }
}
/***********************************/
// MARK: - Expense UI Format
/***********************************/
extension Utilities {
    static func getCategoryName(forExpense expense: Expense) -> String {
        if let category = Singleton.sharedInstance.organization?.categories[expense.categoryId] {
            return category.name
        }
        log.error("Category not found")
        return Constants.General.emptyString
    }
    
    static func getFormattedAmount(forExpense expense: Expense) -> String {
        var currencyAndAmount = Constants.General.emptyString
        
        if let currency = Singleton.sharedInstance.organization?.currencies[expense.currencyId] {
            currencyAndAmount = currency.symbol
        }
        
        currencyAndAmount += " " + String(format: Constants.General.decimalFormat, expense.amount)
        
        return currencyAndAmount
    }
    
    static func getStatus(forExpense expense: Expense) -> String {
        if let status = ExpenseStatus(rawValue: expense.status) {
            return status.name
        }
        log.error("Status of expense is invalid")
        return Constants.General.emptyString
    }
}
/***********************************/
// MARK: - Report UI Format
/***********************************/
extension Utilities {
    static func getFormattedAmount(forReport report: Report) -> String {
        var currencyAndAmount = Constants.General.emptyString
        
        guard let baseCurrencyId = Singleton.sharedInstance.organization?.baseCurrencyId else {
            return String(report.amount)
        }
        
        if let currency = Singleton.sharedInstance.organization?.currencies[baseCurrencyId] {
            currencyAndAmount = currency.symbol
        }
        
        currencyAndAmount += " " + String(format: Constants.General.decimalFormat, report.amount)
        
        return currencyAndAmount
    }
    
    static func getStatus(forReport report: Report) -> String {
        if let status = ReportStatus(rawValue: report.status) {
            return status.name
        }
        log.error("Status of expense is invalid")
        return Constants.General.emptyString
    }
}
/***********************************/
// MARK: - Category Image Name
/***********************************/
extension Utilities {
    static func getCategoryImageName(forId id: String) -> String {
        if let category = Singleton.sharedInstance.organization?.categories[id] {
            // TODO: - Move to constants
            return "Category" + String(category.logo)
        }
        return Constants.General.emptyString
    }
}
/***********************************/
// MARK: - Currency
/***********************************/
extension Utilities {
    static func getCurrencyCode(forId id: String) -> String {
        if let currency = Singleton.sharedInstance.organization?.currencies[id] {
            return currency.code
        }
        return Constants.General.emptyString
    }
}
