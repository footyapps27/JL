//
//  ReportDetailToolBarStrategy.swift
//  JustLogin_MECS
//
//  Created by Samrat on 20/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit


/**
 * This delegate will be called when any button present in the toolbar is tapped.
 * The controller needs to implement this delegate.
 */
@objc protocol ReportDetailsToolBarActionDelegate {
    func barButtonItemTapped(_ sender: UIBarButtonItem)
}

/**
 * The base strategy protocol defining all the required methods that need to be implemented for controlling the toolbar based on the various states of report & the caller of this screen.
 * Since the report detail is being used in both approval & normal report viewing, this has been used.
 */
protocol ReportDetailsToolBarBaseStrategy {
    
    /**
     * When the screen is being loaded, update the number of buttons, their actions & UI of toolbar here.
     * It is also important to keep a track of the buttons using their tag.
     * The perform action will be called when the button is tapped, and the button will be returned.
     * Thus the tag needs to be used as an identifier when there is more than one button.
     */
    func formatToolBar(_ toolBar: UIToolbar, withDelegate delegate: ReportDetailsToolBarActionDelegate)
    
    /**
     * Perform the required action for the button that has been tapped.
     * If there are multiple buttons, identify them using the tag that was set during the format of the toolbar.
     * The controller has been passed, in case some functionalities, such displaying alerts, action sheet requires the same.
     */
    func performActionForBarButtonItem(_ barButton: UIBarButtonItem, forReport report: Report, onController controller: ReportDetailsViewController)
}
