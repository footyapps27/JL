//
//  Styles.swift
//  JustLogin_MECS
//
//  Created by Samrat on 16/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

/***********************************/
// MARK: - Public Methods
/***********************************/
struct Styles {
    static func initialStylesSetup() {
        setupNavigationBar()
        setupTableViewBackground()
        setupTabBar()
        setupSegmentedControl()
        setupUITableViewCellSelection()
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension Styles {
    fileprivate static func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = Color.theme.value
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    fileprivate static func setupTableViewBackground() {
        UITableView.appearance().backgroundColor = Color.background.value
    }
    
    fileprivate static func setupTabBar() {
        UITabBar.appearance().tintColor = Color.theme.value
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = false
    }
    
    fileprivate static func setupSegmentedControl() {
        UISegmentedControl.appearance().tintColor = Color.theme.value
    }
    
    fileprivate static func setupUITableViewCellSelection() {
        // Cell selection color
        let colorView = UIView()
        colorView.backgroundColor = Color.theme.withAlpha(0.15)
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        // Tint Color
        UITableViewCell.appearance().tintColor = Color.theme.value
    }
}
