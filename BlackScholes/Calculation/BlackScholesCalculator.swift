//
//  BlackScholesCalculator.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/28/23.
//

import Foundation
import SigmaSwiftStatistics

public func blackScholesOptionPrice(stockPrice: Double, strikePrice: Double, riskFreeRate: Double, volatility: Double, timeToExpiration: Double, isCall: Bool) -> Double {
    let d1 = (log(stockPrice / strikePrice) + ((riskFreeRate + (pow(volatility, 2) / 2)) * timeToExpiration)) / (volatility * sqrt(timeToExpiration))
    let d2 = d1 - volatility * sqrt(timeToExpiration)
    let optionPrice: Double
    if isCall {
        optionPrice = stockPrice * normalCDF(d1) - strikePrice * exp(-riskFreeRate * timeToExpiration) * normalCDF(d2)
    } else {
        optionPrice = -strikePrice * exp(-riskFreeRate * timeToExpiration) * normalCDF(-d2) + stockPrice * normalCDF(-d1)
    }
    return optionPrice
}

public func normalCDF(_ x: Double) -> Double {
    let pi = 3.14159265358979323846
    let a1 = 0.31938153, a2 = -0.356563782, a3 = 1.781477937, a4 = -1.821255978, a5 = 1.330274429
    let k = 1.0 / (1.0 + 0.2316419 * abs(x))
    let cdf = 1.0 - 1.0 / sqrt(2 * pi) * exp(-pow(x, 2) / 2) * (a1 * k + a2 * pow(k, 2) + a3 * pow(k, 3) + a4 * pow(k, 4) + a5 * pow(k, 5))
    return x < 0 ? 1.0 - cdf : cdf
}
