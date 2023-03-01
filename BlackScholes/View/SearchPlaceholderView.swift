//
//  SearchPlaceholderView.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/26/23.
//

import UIKit

class SearchPlaceholderView: UIView{
    
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "stockAnalysis")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Choose a stock to run a \n Black-Scholes analysis on."
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)!
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
        
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, title])
         stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.setDimensions(width: 88, height: 88)
        
        addSubview(stackView)
        stackView.centerY(inView: self)
        stackView.centerX(inView: self)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
