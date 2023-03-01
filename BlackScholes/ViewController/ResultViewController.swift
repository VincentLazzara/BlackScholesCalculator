//
//  ResultViewController.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/28/23.
//

import UIKit


class ResultViewController: UIViewController{
    
    var schole: Scholes?{
        didSet{
            configureSchole()
        }
    }
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 40)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 54)
        label.numberOfLines = 0
        label.textColor = highlightedColor
        label.textAlignment = .center
        return label
    }()
    
    var accordingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 24)
        label.numberOfLines = 0
        label.text = "According to a \n Black-Scholes analysis"
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var recalculateButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 175, height: 50))
        button.setTitle("Recalculate", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = highlightedColor.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 175).isActive = true
        button.titleLabel?.font =  UIFont(name: "AvenirNext-DemiBold", size: 24)
        button.setTitleColor(highlightedColor, for: .normal)
        button.addTarget(self, action: #selector(recalculateButtonTouched), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        configure()
    }
    
    func configure(){
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 35)
        
        view.addSubview(priceLabel)
        priceLabel.centerX(inView: view, topAnchor: titleLabel.bottomAnchor, paddingTop: 20)
        
        view.addSubview(accordingLabel)
        accordingLabel.centerX(inView: view, topAnchor: priceLabel.bottomAnchor, paddingTop: 30)
        
        view.addSubview(recalculateButton)
        recalculateButton.centerX(inView: view, topAnchor: accordingLabel.bottomAnchor, paddingTop: 80)
        
        view.backgroundColor = .white
    }
    
    @objc func recalculateButtonTouched(){
        self.dismiss(animated: true)
    }
    
    func configureSchole(){
        let optionPrice = blackScholesOptionPrice(schole: schole!)
        
        var isCallString: String?
        
        if schole?.isCall == true{
            isCallString = "Call"
        } else {
            isCallString = "Put"
        }
        
        priceLabel.text = "$\(Double((round(optionPrice * 100)) / 100))"
        titleLabel.text = "\(schole?.ticker ?? "GME") \(isCallString ?? "Call"):"
        
    }
    
}
