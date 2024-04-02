//
//  ChartViewModel.swift
//  CoinBank
//
//  Created by 이은서 on 4/2/24.
//

import Foundation
import Combine

class ChartViewModel: ObservableObject {
    
    @Published var askOrderBook: [OrderBookItem] = []
    @Published var bidOrderBook: [OrderBookItem] = []
    private var cancellable = Set<AnyCancellable>()
    
    func largestAskSize() -> Double {
        return askOrderBook.sorted(by: { $0.size > $1.size }).first!.size
    }
    
    func fetchOrderBook(_ market: String) {
        OrderBookWebSocketManager.shared.openWebSocket()
        OrderBookWebSocketManager.shared.send(market)
        OrderBookWebSocketManager.shared.response
            .receive(on: DispatchQueue.main)
            .sink { orderBook in
                let result = orderBook.units
                let ask = result.map { OrderBookItem(price: $0.askPrice, size: $0.askSize) }.sorted(by: { $0.price > $1.price })
                let bid = result.map { OrderBookItem(price: $0.bidSize, size: $0.bidSize) }.sorted(by: { $0.price > $1.price} )
                
                self.askOrderBook = ask
                self.bidOrderBook = bid
            }
            .store(in: &cancellable)
    }
    
    func closeWebSocket() {
        OrderBookWebSocketManager.shared.closeWebSocket()
    }
    
}
