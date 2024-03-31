//
//  ListViewModel.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation
import Combine

class CoinListViewModel: ObservableObject {
    
    @Published var price = ""
    private var ticker: Ticker = Ticker(code: "", price24h: 0, volume24h: 0, highestPrice: 0, lowestPrice: 0, highestDate: "", lowestDate: "", openingPrice: 0, closingPrice: 0, tradePrice: 0, tradeVolume: 0, tradeTime: "")
    @Published var tickerData = TickerData(price24h: "", volume24h: "", highestPrice: "", lowestPrice: "", highestDate: "", lowestDate: "", openingPrice: "", closingPrice: "", tradePrice: "", tradeVolume: "", tradeTime: "")
    
    private var cancellable = Set<AnyCancellable>()
    
    struct errorReturn: Decodable {
        let message: String
        let name: String
    }
    
    struct TickerData {
        let price24h, volume24h, highestPrice, lowestPrice: String
        let highestDate, lowestDate, openingPrice, closingPrice: String
        let tradePrice, tradeVolume, tradeTime: String
    }
    
    func getPrice(_ market: String) {
        UpbitPriceAPI.shared.requestPrice(market) { value in
            DispatchQueue.main.async {
                self.price = value
            }
        }
    }
    
    
    func fetchTicker(_ market: String) {
        WebSocketManager.shared.openWebSocket()
        WebSocketManager.shared.tickerSend(market)
        WebSocketManager.shared.response
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                self?.tickerData = TickerData(price24h: self?.numberFormatter(ticker.price24h) ?? "",
                                              volume24h: self?.numberFormatter(ticker.volume24h, isPrice: false) ?? "",
                                              highestPrice: self?.numberFormatter(ticker.highestPrice) ?? "",
                                              lowestPrice: self?.numberFormatter(ticker.lowestPrice) ?? "",
                                              highestDate: self?.dateFormatter(ticker.highestDate) ?? "",
                                              lowestDate: self?.dateFormatter(ticker.lowestDate) ?? "",
                                              openingPrice: self?.numberFormatter(ticker.openingPrice) ?? "",
                                              closingPrice: self?.numberFormatter(ticker.closingPrice) ?? "",
                                              tradePrice: self?.numberFormatter(ticker.tradePrice) ?? "",
                                              tradeVolume: self?.numberFormatter(ticker.tradeVolume, isPrice: false) ?? "",
                                              tradeTime: self?.timeFormatter(ticker.tradeTime) ?? "")
            }
            .store(in: &cancellable)
    }
    
    func closeWebSocket() {
        WebSocketManager.shared.closeWebSocket()
    }
    
    func dateFormatter(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yy-MM-dd"
        
        let strDate = formatter.date(from: date)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateStyle = .medium
        
        guard let strDate else { return "99/99/99" }
        return formatter.string(from: strDate)
    }
    
    func timeFormatter(_ time: String) -> String {
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "hhmmss"
        
        let date = formatter.date(from: time)
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        
        guard let date else { return "12:00:00 AM"}
        return formatter.string(from: date)
    }

    func numberFormatter(_ num: Double, isPrice: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = isPrice ? 0 : 15
        
        let result = formatter.string(from: NSNumber(value: num))
        guard let result else { return "1,000원" }
        return isPrice ? result + "원" : result + "개"
    }
    
}
