//
//  Tickets.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation

struct Ticker: Codable, Hashable {
    
//    let code: String
    let market: String?
    let price24h, volume24h: Double
    let highestPrice, lowestPrice: Double
    let highestDate, lowestDate: String
    let openingPrice, closingPrice: Double
    let tradePrice, tradeVolume: Double
    let tradeTime: String
    
    enum CodingKeys: String, CodingKey {
//        case code
        case market
        case price24h = "acc_trade_price_24h"
        case volume24h = "acc_trade_volume_24h"
        case highestPrice = "highest_52_week_price"
        case highestDate = "highest_52_week_date"
        case lowestPrice = "lowest_52_week_price"
        case lowestDate = "lowest_52_week_date"
        case openingPrice = "opening_price"
        case closingPrice = "prev_closing_price"
        case tradePrice = "trade_price"
        case tradeVolume = "trade_volume"
        case tradeTime = "trade_time"
    }
}
