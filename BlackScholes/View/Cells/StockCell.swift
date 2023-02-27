//
//  StockCell.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/25/23.
//

import UIKit

class StockCell: UITableViewCell{
    
    //MARK: Properites
    
    var stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.text = "AMZ"
        return label
    }()
    
    var usdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.text = "USD"
        return label
    }()
    
    var companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.text = "Amazon Inc."
        label.numberOfLines = 2
        label.textAlignment = .right
        return label
    }()
    
    
    //MARK: Lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        let stockStack = UIStackView(arrangedSubviews: [stockLabel, usdLabel])
        stockStack.spacing = 2
        stockStack.axis = .vertical
        
        addSubview(stockStack)
        stockStack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 10)
        
        addSubview(companyNameLabel)
        companyNameLabel.centerY(inView: self)
        companyNameLabel.anchor(left: stockStack.rightAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        
    }
    
    
    func configureData(with searchResult: SearchResult){
        stockLabel.text = searchResult.symbol
        usdLabel.text = "\(searchResult.type) \(searchResult.currency)"
        companyNameLabel.text = searchResult.name
        
        
    }
    
    
    
}
