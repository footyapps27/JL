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
protocol ExpenseDetailsHeaderViewDelegate {
    func attachmentButtonTapped()
}
/***********************************/
// MARK: - Properties
/***********************************/
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
}
/***********************************/
// MARK: - UI update methods
/***********************************/
extension ExpenseDetailsHeaderView {
    
    override func awakeFromNib() {
        
        parentStackViewHeight.constant = CGFloat(50*4)
        
        // Create the dynamic view here.
        var frame = CGRect()
        //frame.origin.x = CGFloat(0)
        //frame.origin.y = 0
        frame.size.width =  CGFloat(320)
        frame.size.height =  CGFloat(50)
        
        
        let view1 = getDynamicView(withFieldName: "Test", andFieldValue: "TestValue")
        //view1.backgroundColor = UIColor.red
        
        let view2 = getDynamicView(withFieldName: "Test", andFieldValue: "TestValue")
        //view2.backgroundColor = UIColor.blue
        
        let view3 = getDynamicView(withFieldName: "Test", andFieldValue: "TestValue")
        //view3.backgroundColor = UIColor.green
        
        let view4 = getDynamicView(withFieldName: "Test", andFieldValue: "TestValue")
        //view4.backgroundColor = UIColor.yellow
        
        parentStackView.addArrangedSubview(view1)
        parentStackView.addArrangedSubview(view2)
        parentStackView.addArrangedSubview(view3)
        parentStackView.addArrangedSubview(view4)
        
        
//        parentStackView.addSubview(ExpenseDetailsStackView())
//        parentStackView.addSubview(ExpenseDetailsStackView())
//        parentStackView.addSubview(ExpenseDetailsStackView())
//        parentStackView.addSubview(ExpenseDetailsStackView())
        
//        let view = ExpenseDetailsStackView()
//        view.backgroundColor
//        view.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
//        view.widthAnchor.constraint(equalToConstant: CGFloat(320)).isActive = true
//        parentStackView.addArrangedSubview(view)
        //parentStackView.addSubview(view)
        
        
    }
    
    func updateView(withExpense expense: Expense) {
        
    }
    
    func getHeight() -> CGFloat {
        // Only return the additional height, since the header is already added to the storyboard.
        return CGFloat(50*4)
        //return CGFloat(300 + (50*2))
    }
}

extension ExpenseDetailsHeaderView {
    
    func getDynamicView(withFieldName fieldName: String, andFieldValue fieldValue: String) -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
