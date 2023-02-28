//
//  CalculateViewController.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/27/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields


/*
 TODO:
 -Input mask % for text field
 -Add remaining textfields
 -Add API name configuration
 -Make API call to fetch current price
 
 */


class CalculateViewController: UIViewController{
    
    //MARK: Properties
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        label.text = "Black-Scholes \n Calculation for \n Stock Name"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
   var stockInfo = StockInfoView()
    
    
    
    private let volitilityInput: MDCOutlinedTextField = {
        let tf = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: 250, height: 15))
        tf.placeholder = "%"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.label.text = "Volitility %"
        tf.setFloatingLabelColor(.cyan, for: .editing)
        tf.setOutlineColor(.cyan, for: .editing)
        tf.textAlignment = .right
        return tf
        
    }()
    
    
    
    //MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    
    func configureUI(){
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 100)
        
        view.addSubview(stockInfo)
        stockInfo.centerX(inView: view, topAnchor: titleLabel.bottomAnchor, paddingTop: 25)
        stockInfo.anchor(height: 125)
        stockInfo.anchor(left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(volitilityInput)
        volitilityInput.centerX(inView: view, topAnchor: stockInfo.bottomAnchor, paddingTop: 15)
        volitilityInput.delegate = self
        volitilityInput.keyboardType = .numberPad
    }

    
    
}


//MARK: Text Field Delegate

extension CalculateViewController: UISearchTextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
               return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         // Convert the input into a number with one decimal place
         let formatter = NumberFormatter()
         formatter.numberStyle = .percent
         formatter.maximumFractionDigits = 1
         let number = formatter.number(from: textField.text ?? "")?.doubleValue ?? 0.0
         
         // Format the number as a percentage with one decimal place
         textField.text = formatter.string(from: NSNumber(value: number))
     }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          // Allow an empty string as a valid input
          if string.isEmpty {
              return true
          }
          
          let currentText = textField.text ?? ""
          let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
          
          // Convert the input into a number with one decimal place
          let formatter = NumberFormatter()
          formatter.numberStyle = .percent
          formatter.maximumFractionDigits = 1
          let number = formatter.number(from: updatedText)?.doubleValue ?? 0.0
          
          // Check if the input is within the desired range
          let isValid = (0.0...1.0).contains(number)
          
          if isValid {
              // Format the number as a percentage with one decimal place
              textField.text = formatter.string(from: NSNumber(value: number))
              return false
          }
          
          // Allow the input of the decimal point if the current text does not contain a decimal point
          if string == "." && !currentText.contains(".") && !updatedText.isEmpty {
              // Append the decimal point to the current text
              textField.text = updatedText + "."
              return false
          }
          
          return false
      }

  }





    


