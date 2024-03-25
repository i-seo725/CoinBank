//
//  API.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation

struct Market: Codable, Hashable {
    let market: String
    let korean: String
    let english: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case korean = "korean_name"
        case english = "english_name"
    }
}
