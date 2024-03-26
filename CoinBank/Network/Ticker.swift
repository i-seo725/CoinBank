//
//  Tickets.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation

struct Ticker: Codable, Hashable {
    
    let market: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case price = "trade_price"
        case market
    }
}
