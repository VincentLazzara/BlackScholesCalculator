//
//  BlackScholesCalculator.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 3/1/23.
//

import Foundation
import SigmaSwiftStatistics

func blackScholesOptionPrice(schole: Scholes) -> Double {
    
    let s = schole.stock
    let v = schole.volatility
    let t = schole.time
    let r = schole.risk
    let d = schole.dividend
    let k = schole.strike
    let isCall = schole.isCall
    
    
    let d00 = (log(s / k))
    //ln(s/k)
                
    let d01 = (pow(v, 2) * 0.5)
    //1/2vol^2
    
    let d02 = d00 + ((r - d + d01) * t)
    //d00 + (r - d + 1/2vol^2)t
    
    let d1 = d02 / (v * sqrt(t))
    //[ln(s/k) + (r - d + 1/2vol^2)t] / volt * sqrt(t)
    
    let d2 = d1 - (v * sqrt(t))
    
    //Normal distribution Z table calculation
    let D1 = Sigma.normalDistribution(x: d1)
    let D2 = Sigma.normalDistribution(x: d2)
    
    //Negative normal distribution Z table calculation
    let ND1 = Sigma.normalDistribution(x: -Double(d1)) ?? 1.00
    let ND2 = Sigma.normalDistribution(x: -Double(d2)) ?? 1.00
    
    let stockPriceDiscounted = s * exp(-d * t) //Se^rt
    let strikePriceDiscounted = k * exp(-r * t) //Ke^rt
        
        if isCall {
            return  stockPriceDiscounted * (D1 ?? 0.00) - strikePriceDiscounted * (D2 ?? 0.00)
        } else {
            return strikePriceDiscounted * ND2 - stockPriceDiscounted * ND1
        }
    

}
