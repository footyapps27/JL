//
//  SettingsTableProfileSectionHeaderView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 13/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableProfileSectionHeaderView: UIView {
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblOrganization: UILabel!
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    class func instanceFromNib() -> SettingsTableProfileSectionHeaderView {
        return UINib(nibName: String(describing: SettingsTableProfileSectionHeaderView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView as! SettingsTableProfileSectionHeaderView
    }
    
    /***********************************/
    // MARK: - View Lifecycle
    /***********************************/
    
    override func awakeFromNib() {
        
    }
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
}
