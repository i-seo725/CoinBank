//
//  Orderbook.swift
//  CoinBank
//
//  Created by 이은서 on 4/3/24.
//

import Foundation

struct OrderBook: Decodable {
    let code: String
    let timestamp: Int
    let totalAskSize, totalBidSize: Double
    let units: [OrderBookUnit]
    
    enum CodingKeys: String, CodingKey {
        case code, timestamp
        case totalAskSize = "total_ask_size"
        case totalBidSize = "total_bid_size"
        case units = "orderbook_units"
    }
}

struct OrderBookUnit: Decodable {
    let askPrice, bidPrice: Double
    let askSize, bidSize: Double
    
    enum CodingKeys: String, CodingKey {
        case askSize = "total_ask_size"
        case bidSize = "total_bid_size"
        case askPrice = "ask_price"
        case bidPrice = "bid_price"
    }
}

//위 구조체는 서버에서 오는 값
//아래는 뷰에서 사용하기 위해 가공하는 모델

struct OrderBookItem: Hashable, Identifiable {
    let id = UUID()
    let price: Double
    let size: Double
}
