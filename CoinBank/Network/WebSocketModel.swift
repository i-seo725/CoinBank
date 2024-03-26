//
//  WebSocketModel.swift
//  CoinBank
//
//  Created by 이은서 on 3/26/24.
//

import Foundation

struct WebSocketModel: Decodable {
    
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case price = "trade_price"
    }
}
