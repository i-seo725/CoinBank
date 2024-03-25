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


struct UpbitAPI {
    
    private init() { }
    
    static func fetchAllMarket(handler: @escaping ([Market])  -> Void) {
        
        let url = URL(string: "https://api.upbit.com/v1/market/all")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                print("데이터 응답값 없음")
                return
            }
            
            do {
                let data = try JSONDecoder().decode([Market].self, from: data)
                handler(data)
            } catch {
                print(error)
            }
            
        }.resume()
        
    }
}
