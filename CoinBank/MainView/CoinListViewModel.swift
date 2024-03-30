//
//  ListViewModel.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation

class CoinListViewModel: ObservableObject {
    
    @Published var market: [Market] = [Market(market: "마켓", korean: "한국어", english: "영어")]
    @Published var price = ""
    @Published var coinName = "목록에서 코인 선택"
    //    @Published var ticker: [Ticker] = []
    //    @Published var mainData: [mainViewData] = []
    
    var lastDate: Date?
    
    struct mainViewData {
        let korean: String
        let english: String
        let market: String
        let price: Double
    }
    
    struct errorReturn: Decodable {
        let message: String
        let name: String
    }
    
    func updateCoinName(_ name: String) {
        coinName = name
        print(name)
    }
    
    func getPrice(_ market: String) {
        UpbitPriceAPI.shared.requestPrice(market) { value in
            DispatchQueue.main.async {
                self.price = value
            }
        }
    }
}
