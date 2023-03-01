//
//  CalculateViewController.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/27/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields


class CalculateViewController: UIViewController{
    
    //MARK: Properties
    
    let viewModel = CalculateViewModel()
    
    var titleLabel = UILabel()
    
    var stockInfo = StockInfoView()
    
    var volatilityInput = MDCOutlinedTextField()
    var termInput = MDCOutlinedTextField()
    var strikeInput = MDCOutlinedTextField()
    var riskInput = MDCOutlinedTextField()
    var dividendInput = MDCOutlinedTextField()
    
    let testView = UIView()
    var callButton = UIButton()
    var putButton = UIButton()
    
    var errorLabel = UILabel()
    var calculateButton = UIButton()
    
    //Computation Properties
    
    var companyInfo: SearchResult?{
        didSet{
            stockInfo.stockTickerLabel.text = "\(companyInfo?.symbol ?? "GME")"
            stockInfo.stockInfoLabel.text = "\(companyInfo?.type ?? "Stock") \(companyInfo?.currency ?? "USD")"
            
        }
    }
    
    
    var isCall = true
    var volatility = 0.00
    var strikePrice = 0.00
    var stockPrice: Double?{
        didSet{
            stockInfo.currentValueNumberLabel.text = "\(stockPrice ?? 0.0)"
        }
    }
    var riskRate = 0.00
    var time = 0.00
    var divided = 0.00
    
    //MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    
    func configureUI(){
        
        self.titleLabel = viewModel.titleLabel
        self.volatilityInput = viewModel.volitilityInput
        self.termInput = viewModel.termInput
        self.strikeInput = viewModel.strikeInput
        self.riskInput = viewModel.riskInput
        self.callButton = viewModel.callButton
        self.putButton = viewModel.putButton
        self.errorLabel = viewModel.errorLabel
        self.calculateButton = viewModel.calculateButton
        self.dividendInput = viewModel.dividendInput
        
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 80)
        titleLabel.text = "Black-Scholes Calculation \n for \(companyInfo?.name ?? "Black Scholes \n calculator")"
        
        view.addSubview(testView)
        testView.setDimensions(width: 200, height: 2)
        testView.centerX(inView: view, topAnchor: titleLabel.bottomAnchor, paddingTop: 13)
        
        view.addSubview(callButton)
        callButton.anchor(top: testView.bottomAnchor, left: testView.leftAnchor)
        callButton.addTarget(self, action: #selector(callButtonTouched), for: .touchUpInside)

        view.addSubview(putButton)
        putButton.anchor(top: testView.bottomAnchor, left: callButton.rightAnchor)
        putButton.addTarget(self, action: #selector(putButtonTouched), for: .touchUpInside)
        
        view.addSubview(stockInfo)
        stockInfo.centerX(inView: view, topAnchor: putButton.bottomAnchor, paddingTop: 15)
        stockInfo.anchor(height: 80)
        stockInfo.anchor(left: view.leftAnchor, right: view.rightAnchor)
        stockInfo.isUserInteractionEnabled = true
        
        view.addSubview(strikeInput)
        strikeInput.anchor(top: stockInfo.bottomAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 10)
        strikeInput.delegate = self
        
        
        view.addSubview(termInput)
        termInput.centerX(inView: strikeInput, topAnchor: strikeInput.bottomAnchor, paddingTop: 15)
        termInput.delegate = self
        
        view.addSubview(riskInput)
        riskInput.centerX(inView: termInput, topAnchor: termInput.bottomAnchor, paddingTop: 15)
        riskInput.delegate = self
        
        
        view.addSubview(volatilityInput)
        volatilityInput.anchor(top: stockInfo.bottomAnchor, right: view.rightAnchor, paddingTop: 25, paddingRight: 10)
        volatilityInput.delegate = self
        
        view.addSubview(dividendInput)
        dividendInput.centerX(inView: volatilityInput, topAnchor: volatilityInput.bottomAnchor, paddingTop: 15)
        dividendInput.delegate = self
        
        
        view.addSubview(errorLabel)
        errorLabel.centerX(inView: view, topAnchor: riskInput.bottomAnchor, paddingTop: 20)
        errorLabel.isHidden = true
        
        view.addSubview(calculateButton)
        calculateButton.centerX(inView: view, topAnchor: errorLabel.bottomAnchor, paddingTop: 5)
        calculateButton.addTarget(self, action: #selector(calculateButtonTouched), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editPriceTapped))
        stockInfo.editView.addGestureRecognizer(tapGestureRecognizer)
            
    
    }

    
    @objc private func callButtonTouched() {
        isCall = true
        UIView.animate(withDuration: 0.1, animations: {
            self.callButton.backgroundColor = highlightedColor.darker(by: 15)
            self.putButton.backgroundColor = UIColor.optionGray
           }) { _ in
               UIView.animate(withDuration: 0.1, animations: {
                   self.callButton.backgroundColor = highlightedColor
               })
           }
    }
    
    @objc private func putButtonTouched() {
        isCall = false
        
        UIView.animate(withDuration: 0.1, animations: {
            self.callButton.backgroundColor = UIColor.optionGray
            self.putButton.backgroundColor = highlightedColor.darker(by: 15)
           }) { _ in
               UIView.animate(withDuration: 0.1, animations: {
                   self.putButton.backgroundColor = highlightedColor
               })
           }
    }
    
    @objc private func calculateButtonTouched() {
        UIView.animate(withDuration: 0.1, animations: {
            self.calculateButton.backgroundColor = highlightedColor.darker(by: 15)
           }) { _ in
               UIView.animate(withDuration: 0.1, animations: {
                   self.calculateButton.backgroundColor = highlightedColor
               })
           }
        let isSearchFieldsPopulated = searchIfFieldsEmpty()
    
        if isSearchFieldsPopulated {
            self.volatility = stringToDouble(string: volatilityInput.text ?? "1.00") / 100
            self.time = stringToDouble(string: termInput.text ?? "1.00")
            self.strikePrice = stringToDouble(string: strikeInput.text ?? "1.00")
            self.riskRate = stringToDouble(string: riskInput.text ?? "1.00") / 100
            self.divided = stringToDouble(string: dividendInput.text ?? "0.00") / 100
            
            let schole = Scholes(strike: strikePrice, stock: stockPrice ?? 0.00,
                                 risk: riskRate, time: time, volatility: volatility, dividend: divided,
                                 ticker: companyInfo?.symbol ?? "GME", name: companyInfo?.name ?? "Company", isCall: isCall)

            
            let nav = ResultViewController()
            nav.schole = schole
            self.present(nav, animated: true)
            
        } else {
            return
      }
    }
    
    func stringToDouble(string: String) -> Double{
        let text = string.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        return Double(text)!
    }
    
  
    
    
    //If the stock price isn't updated or correct, this allows the user to edit the price themselves
    @objc private func editPriceTapped(){

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit \(companyInfo?.symbol ?? "GME")'s stock price", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Change Price", style: .default) { (action) in
            //User clicks add item button
            self.stockPrice = Double(textField.text ?? "0.00")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "$5.87"
            alertTextField.keyboardType = UIKeyboardType.decimalPad
            textField = alertTextField
        }
                           
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK: Text Field Delegate

extension CalculateViewController: UISearchTextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
               return true
        
    }
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let oldText = textField.text else { return false }
        
        if textField == volatilityInput{
            if string.isEmpty { // this means that backspace is pressed
                let oldDigits = textField.text?.digits
                // drops one digit every time backspace is pressed
                let newNumber = Double(oldDigits?.dropLast() ?? "0.0")
                textField.text = viewModel.percentFormatter.string(for: (newNumber ?? 0) / 10000)
            } else // something has been entered
            if let newNumber = Double(
                (oldText as NSString).replacingCharacters(in: range, with: string).digits
            ) {
                textField.text = viewModel.percentFormatter.string(for: newNumber / 10000)
            }
            return false
        } else if textField == termInput{
            if string.isEmpty { // this means that backspace is pressed
                let oldDigits = textField.text?.digits
                // drops one digit every time backspace is pressed
                let newNumber = Double(oldDigits?.dropLast() ?? "0")
                textField.text = viewModel.termFormatter.string(for: (newNumber ?? 0) / 100)
            }else // something has been entered
            if let newNumber = Double(
                (oldText as NSString).replacingCharacters(in: range, with: string).digits
            ) {
                textField.text = viewModel.termFormatter.string(for: newNumber / 100)
            }
            return false
        } else if textField == strikeInput{
            if string.isEmpty { // this means that backspace is pressed
                let oldDigits = textField.text?.digits
                // drops one digit every time backspace is pressed
                let newNumber = Double(oldDigits?.dropLast() ?? "0.0")
                textField.text = viewModel.strikeFormatter.string(for: (newNumber ?? 0) / 100)
            } else // something has been entered
            if let newNumber = Double(
                (oldText as NSString).replacingCharacters(in: range, with: string).digits
            ) {
                textField.text = viewModel.strikeFormatter.string(for: newNumber / 100)
            }
            return false
    
        } else if textField == riskInput{
            if string.isEmpty { // this means that backspace is pressed
                let oldDigits = textField.text?.digits
                // drops one digit every time backspace is pressed
                let newNumber = Double(oldDigits?.dropLast() ?? "0.0")
                textField.text = viewModel.percentFormatter.string(for: (newNumber ?? 0) / 10000)
            } else // something has been entered
            if let newNumber = Double(
                (oldText as NSString).replacingCharacters(in: range, with: string).digits
            ) {
                textField.text = viewModel.percentFormatter.string(for: newNumber / 10000)
            }
            return false
        } else if textField == dividendInput{
            if string.isEmpty { // this means that backspace is pressed
                let oldDigits = textField.text?.digits
                // drops one digit every time backspace is pressed
                let newNumber = Double(oldDigits?.dropLast() ?? "0.0")
                textField.text = viewModel.percentFormatter.string(for: (newNumber ?? 0) / 10000)
            } else // something has been entered
            if let newNumber = Double(
                (oldText as NSString).replacingCharacters(in: range, with: string).digits
            ) {
                textField.text = viewModel.percentFormatter.string(for: newNumber / 10000)
            }
            return false
            
            
        }
        
        return false
        }
        

  }

extension CalculateViewController{
    
    
    func searchIfFieldsEmpty()-> Bool{
        
        if volatilityInput.text == ""{
            errorLabel.text = "Enter the volatility"
            errorLabel.isHidden = false
            return false
        } else if termInput.text == ""{
            errorLabel.text = "Enter the term"
            errorLabel.isHidden = false
            return false
        } else if strikeInput.text == ""{
            errorLabel.text = "Enter the strike price"
            errorLabel.isHidden = false
            return false
        }else if riskInput.text == ""{
            errorLabel.text = "Enter the risk-free rate"
            errorLabel.isHidden = false
            return false
        }else if dividendInput.text == ""{
            errorLabel.text = "Enter the dividend rate"
            errorLabel.isHidden = false
            return false
        }else {
            errorLabel.isHidden = true
            return true
        }
        
        
        
        
    }
    
    
    
}






    


