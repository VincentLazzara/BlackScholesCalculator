//
//  StockInfoView.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/27/23.
//

import UIKit


class StockInfoView: UIView{
    
    //MARK: Properties
    var stockTickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.text = "GME"
        label.textAlignment = .left
        return label
    }()
    
    var stockInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 14)
        label.text = "S&P 500 ETF"
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    var currentValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 12)
        label.text = "Current Value"
        label.textAlignment = .left
        return label
    }()
    
    var currentValueNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 24)
        label.text = "5000"
        label.textAlignment = .left
        return label
    }()
    
    
    
    //MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        addSubview(stockTickerLabel)
        stockTickerLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 5, paddingLeft: 15)
        
        addSubview(stockInfoLabel)
        stockInfoLabel.centerY(inView: stockTickerLabel, leftAnchor: stockTickerLabel.rightAnchor, paddingLeft: 10)
        
        addSubview(currentValueLabel)
        currentValueLabel.anchor(top: stockTickerLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 15)
        
        addSubview(currentValueNumberLabel)
        currentValueNumberLabel.anchor(top: currentValueLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 15)
        
    }
    
    
}
