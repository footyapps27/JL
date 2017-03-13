//
//  ExpenseDetailsHeaderView.swift
//  JustLogin_MECS
//
//  Created by Samrat on 2/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/***********************************/
// MARK: - Protocol Declaration
/***********************************/
protocol ExpenseDetailsHeaderViewDelegate: class {
    
    func attachmentButtonTapped()
}
/***********************************/
// MARK: - Properties
/***********************************/

/**
 * For expense since the header view is dynamically changed based on the properties present in the expense, the decision to go ahead with a separate file was taken.
 */
class ExpenseDetailsHeaderView: UIView {
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblExpenseDetails: UILabel!
    
    @IBOutlet weak var lblExpenseHistory: UILabel!
    
    @IBOutlet weak var btnAttachment: UIButton!
    
    @IBOutlet weak var btnPolicyViolation: UIButton!
    
    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet weak var parentStackViewHeight: NSLayoutConstraint!
    
    weak var delegate: ExpenseDetailsHeaderViewDelegate?
    
    /***********************************/
    // MARK: - Initializer
    /***********************************/
    class func instanceFromNib() -> ExpenseDetailsHeaderView {
        return UINib(nibName: String(describing: ExpenseDetailsHeaderView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView as! ExpenseDetailsHeaderView
    }
}
/***********************************/
// MARK: - UI update methods
/***********************************/
extension ExpenseDetailsHeaderView {
    func updateView(withManager manager: ExpenseDetailsManager) {
        lblCategory.text = manager.getCategoryName()
        lblAmount.text = manager.getFormattedAmount()
        lblStatus.text = manager.getExpenseStatus()
        lblDate.text = manager.getExpenseDate()
        
        if !manager.expense.hasPolicyViolation {
            btnPolicyViolation.removeFromSuperview()
        }
        
        for dict in manager.getFieldsToDisplay() {
            let view = getDynamicView(withFieldName: dict.key, andFieldValue: dict.value)
            parentStackView.addArrangedSubview(view)
            parentStackViewHeight.constant += CGFloat(50)
        }
    }
    
    /**
     * The height of the view after the stack view has been dynamically populated.
     */
    func getHeight() -> CGFloat {
        return CGFloat(Constants.UISize.expenseHeaderViewIntialHeight) + parentStackViewHeight.constant
    }
}
/***********************************/
// MARK: - Action
/***********************************/
extension ExpenseDetailsHeaderView {
    @IBAction func attachmentTapped(_ sender: UIButton) {
        delegate?.attachmentButtonTapped()
    }
    
    @IBAction func policyViolationTapped(_ sender: UIButton) {
        // TODO: - Handle the view update here
    }
}
/***********************************/
// MARK: - Private Methods
/***********************************/
extension ExpenseDetailsHeaderView {
    
    func getDynamicView(withFieldName fieldName: String, andFieldValue fieldValue: String) -> UIView {
        
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
