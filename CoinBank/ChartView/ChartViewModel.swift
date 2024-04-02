//
//  ChartViewModel.swift
//  CoinBank
//
//  Created by 이은서 on 4/2/24.
//

import Foundation
import Combine

class ChartViewModel: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchOrderBook(_ market: String) {
        OrderBookWebSocketManager.shared.openWebSocket()
        OrderBookWebSocketManager.shared.send(market)
        OrderBookWebSocketManager.shared.response
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orderBook in
                
            }
            .store(in: &cancellable)
    }
    
    func closeWebSocket() {
        OrderBookWebSocketManager.shared.closeWebSocket()
    }
    
}
