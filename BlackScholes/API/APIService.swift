//
//  APIService.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/25/23.
//

import Foundation
import Combine

struct APIService{
    
    var API_KEY: String{
        return keys.randomElement() ?? "BENE0WJJ8F1UN9T4"
    }
    
    let keys = ["BENE0WJJ8F1UN9T4", "MRKKI0O7MA1ZAESJ", "N483IC64XUG8M4VQ", "HXMUNDJIX81H2UDJ", "6DUG1TOBABY1SOPG"]
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        let url = URL(string: urlString)!
        return URLSession.shared
            .dataTaskPublisher(for: url).map({ $0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
   
}
