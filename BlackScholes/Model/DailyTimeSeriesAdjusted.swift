//
//  DailyTimeSeriesAdjusted.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/28/23.
//

import Foundation


struct IntraDayInfo{
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

struct DailyTimeSeriesAdjusted: Decodable{
    
    let meta: Meta
    
    let timeSeries: [String:OpenClose]
    
    enum CodingKeys: String, CodingKey{
        case meta = "Meta Data"
        case timeSeries = "Time Series (5min)"
    }
     
    func getIntraInfo() -> [IntraDayInfo]{
        var intraInfo: [IntraDayInfo] = []
        
        let sortedTimeSeries = timeSeries.sorted { (pair1, pair2) -> Bool in
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let time1 = dateFormatter.date(from: pair1.key)!
            let time2 = dateFormatter.date(from: pair2.key)!
            return time1 > time2 // sort by time
            
        }
        sortedTimeSeries.forEach { (date, ohlc) in
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: date)!
            let dateInfo = IntraDayInfo(date: date, adjustedOpen: Double(ohlc.open)!, adjustedClose: Double(ohlc.close)!)
            intraInfo.append(dateInfo)
        }
        return intraInfo
    }
    
    
    
    
    
}

struct Meta: Decodable{
    let symbol: String
    enum CodingKeys: String, CodingKey{
        case symbol = "2. Symbol"
    }
    
}

//Open High Low Close
struct OpenClose: Decodable{
    let open: String
    let close: String
    
    enum CodingKeys: String, CodingKey{
        case open = "1. open"
        case close = "4. close"
    }
}
