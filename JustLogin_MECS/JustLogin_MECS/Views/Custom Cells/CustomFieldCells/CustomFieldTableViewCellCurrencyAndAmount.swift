//
//  CustomFieldTableViewCellCurrencyAndAmount.swift
//  JustLogin_MECS
//
//  Created by Samrat on 23/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldTableViewCellCurrencyAndAmount: CustomFieldBaseTableViewCell {
    /***********************************/
    // MARK: - Outlets
    /***********************************/
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet weak var txtAmount: UITextField!
    
    var selectedCurrencyId: String?
    
    /***********************************/
    // MARK: - Parent method override
    /***********************************/
    override func updateView(withField field: CustomField) {
        if let id = field.values[Constants.CustomFieldKeys.id] {
            selectedCurrencyId = id
        }
        lblCurrency.text = field.values[Constants.CustomFieldKeys.value]
        txtAmount.text = field.values[Constants.CustomFieldKeys.amount]
    }
    
    override func validateInput(withField field: CustomField) -> (success: Bool, errorMessage: String) {
        if field.isMandatory && txtAmount.text!.isEmpty {
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
    
    override func getPayload(withField reportField: CustomField) -> [String : Any] {
        var payload: [String : Any] = [:]
        if selectedCurrencyId != nil {
            payload[Constants.RequestParameters.Expense.currencyId] = selectedCurrencyId!
            payload[Constants.RequestParameters.Expense.amount] = (Double(txtAmount.text!) ?? 0.00)
            
            /* This check will be enabled in Phase 2
             // If it is the base currency, then we send the exchange rate as 1.00 by default
             if selectedCurrencyId == Singleton.sharedInstance.organization?.baseCurrencyId {
             payload[Constants.RequestParameters.Expense.exchange] = Constants.Defaults.exchangeRate
             }
             
             */
            
            // Remove this once the above is enabled.
            payload[Constants.RequestParameters.Expense.exchange] = Constants.Defaults.exchangeRate
        }
        return payload
    }
}
/***********************************/
// MARK: - View Lifecycle
/***********************************/
extension CustomFieldTableViewCellCurrencyAndAmount {
    override func awakeFromNib() {
        txtAmount.tag = CustomFieldType.currencyAndAmount.rawValue
        if let organization = Singleton.sharedInstance.organization {
            selectedCurrencyId = organization.baseCurrencyId
            lblCurrency.text = Utilities.getCurrencyCode(forId: organization.baseCurrencyId)
        }
    }
}
