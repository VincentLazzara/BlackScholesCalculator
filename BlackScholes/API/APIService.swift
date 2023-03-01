//
//  APIService.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/25/23.
//

import Foundation
import Combine

struct APIService{
    
    enum APIServiceError: Error{
        case encoding
        case badRequest
    }
    
    var API_KEY: String{
        return keys.randomElement() ?? "BENE0WJJ8F1UN9T4"
    }
    
    let keys = ["BENE0WJJ8F1UN9T4", "MRKKI0O7MA1ZAESJ", "N483IC64XUG8M4VQ", "HXMUNDJIX81H2UDJ", "6DUG1TOBABY1SOPG"]
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else
            { return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()}
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        
        guard let url = URL(string: urlString) else {return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()}
        
        return URLSession.shared
            .dataTaskPublisher(for: url).map({ $0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
    
    func fetchStockPrice(keywords: String) -> AnyPublisher<DailyTimeSeriesAdjusted, Error>{
        
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else
            { return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()}
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(keywords)&interval=5min&apikey=\(API_KEY)"
        
        guard let url = URL(string: urlString) else {return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()}
        
        return URLSession.shared
            .dataTaskPublisher(for: url).map({ $0.data})
            .decode(type: DailyTimeSeriesAdjusted.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    
    
    
   
}
