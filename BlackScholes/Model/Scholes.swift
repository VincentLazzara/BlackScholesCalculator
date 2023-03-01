//
//  Scholes.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 3/1/23.
//

import Foundation

//Model for Black-Scholes calculation + other stock information

struct Scholes{
    var strike: Double
    var stock: Double
    var risk: Double
    var time: Double
    var volatility: Double
    var dividend: Double
    var ticker: String
    var name: String
    var isCall: Bool
}
