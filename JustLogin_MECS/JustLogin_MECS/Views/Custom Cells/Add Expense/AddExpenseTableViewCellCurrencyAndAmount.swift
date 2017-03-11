//
//  AddExpenseCurrencyAndAmountTableViewCell.swift
//  JustLogin_MECS
//
//  Created by Samrat on 7/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseTableViewCellCurrencyAndAmount: AddExpenseBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet weak var txtAmount: UITextField!
    
    var selectedCurrencyId: String?
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField expenseField: ExpenseAndReportField) {
        
    }
    
    override func validateInput(withField expenseField: ExpenseAndReportField) -> (success: Bool, errorMessage: String) {
        if expenseField.isMandatory && txtAmount.text!.isEmpty {
            return (false, "Please make sure 'Amount' has been entered.")
        }
        
        guard (Double(txtAmount.text!) != nil) else {
            return (false, "Please enter a valid amount. Only decimals allowed")
        }
        
        return(true, Constants.General.emptyString)
    }
    
    override func updateView(withId id: String, value: String) {
        selectedCurrencyId = id
        lblCurrency.text = value
    }
    
    override func getPayload(withField reportField: ExpenseAndReportField) -> [String : Any] {
        if selectedCurrencyId != nil {
            return [
                Constants.RequestParameters.Expense.currencyId : selectedCurrencyId!,
                Constants.RequestParameters.Expense.amount : (Double(txtAmount.text!) ?? 0.00)
            ]
        }
        return [:]
    }
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension AddExpenseTableViewCellCurrencyAndAmount {
    override func awakeFromNib() {
        txtAmount.tag = ExpenseAndReportFieldType.currencyAndAmount.rawValue
        if let organization = Singleton.sharedInstance.organization {
            selectedCurrencyId = organization.baseCurrencyId
            lblCurrency.text = Utilities.getCurrencyCode(forId: organization.baseCurrencyId)
        }
    }
}
