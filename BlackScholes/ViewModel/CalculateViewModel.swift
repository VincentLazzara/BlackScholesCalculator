//
//  CalculateViewModel.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/28/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

public class CalculateViewModel{
    
    let percentFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.maximumIntegerDigits = 2
        f.numberStyle = .percent
        f.locale = Locale(identifier: "en-US_POSIX")
        return f
    }()
    
    let termFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 0
        f.maximumIntegerDigits = 2
        f.numberStyle = .none
        f.locale = Locale(identifier: "en-US_POSIX")
        return f
    }()
    
    let strikeFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        f.maximumIntegerDigits = 4
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en-US_POSIX")
        return f
    }()
    
    
    let volitilityInput: MDCOutlinedTextField = {
        let tf = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        tf.placeholder = "%"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.label.text = "Volatility %"
        tf.font = UIFont(name: "AvenirNext-Medium", size: 14)
        tf.setFloatingLabelColor(highlightedColor, for: .editing)
        tf.setOutlineColor(highlightedColor, for: .editing)
        tf.sizeToFit()
        tf.doneAccessory = true
        tf.keyboardType = .asciiCapableNumberPad
        tf.addDoneButtonOnKeyboard()
        tf.preferredContainerHeight = 20
        tf.verticalDensity = 2
        tf.textAlignment = .right
        return tf
    }()
    
   let termInput: MDCOutlinedTextField = {
        let tf = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        tf.placeholder = "Years"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.label.text = "Term (Years)"
        tf.font = UIFont(name: "AvenirNext-Medium", size: 14)
        tf.setFloatingLabelColor(highlightedColor, for: .editing)
        tf.setOutlineColor(highlightedColor, for: .editing)
        tf.sizeToFit()
        tf.doneAccessory = true
        tf.keyboardType = .asciiCapableNumberPad
        tf.addDoneButtonOnKeyboard()
        tf.preferredContainerHeight = 20
        tf.verticalDensity = 2
        tf.textAlignment = .right
        return tf
    }()
    
    let strikeInput: MDCOutlinedTextField = {
        let tf = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        tf.placeholder = "$"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.label.text = "Strike Price"
        tf.font = UIFont(name: "AvenirNext-Medium", size: 14)
        tf.setFloatingLabelColor(highlightedColor, for: .editing)
        tf.setOutlineColor(highlightedColor, for: .editing)
        tf.sizeToFit()
        tf.doneAccessory = true
        tf.keyboardType = .asciiCapableNumberPad
        tf.addDoneButtonOnKeyboard()
        tf.preferredContainerHeight = 20
        tf.verticalDensity = 2
        tf.textAlignment = .right
        return tf
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let riskInput: MDCOutlinedTextField = {
        let tf = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        tf.placeholder = "%"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.label.text = "Risk-Free Interest Rate"
        tf.font = UIFont(name: "AvenirNext-Medium", size: 14)
        tf.setFloatingLabelColor(highlightedColor, for: .editing)
        tf.setOutlineColor(highlightedColor, for: .editing)
        tf.sizeToFit()
        tf.doneAccessory = true
        tf.keyboardType = .asciiCapableNumberPad
        tf.addDoneButtonOnKeyboard()
        tf.preferredContainerHeight = 20
        tf.verticalDensity = 2
        tf.textAlignment = .right
        return tf
    }()
    
  
   

    lazy var callButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.setTitle("Call", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.titleLabel?.font =  UIFont(name: "AvenirNext-Medium", size: 18)
        button.backgroundColor = highlightedColor
        button.isUserInteractionEnabled = true
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var putButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.setTitle("Put", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.titleLabel?.font =  UIFont(name: "AvenirNext-Medium", size: 18)
        button.backgroundColor = .lightGray
        button.isUserInteractionEnabled = true
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.text = "Add the volatility"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    lazy var calculateButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 175, height: 50))
        button.setTitle("Calculate", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 175).isActive = true
        button.titleLabel?.font =  UIFont(name: "AvenirNext-DemiBold", size: 24)
        button.backgroundColor = highlightedColor
        button.setTitleColor(.white, for: .normal)
        return button
    }()



    
 
 
    
    
}
