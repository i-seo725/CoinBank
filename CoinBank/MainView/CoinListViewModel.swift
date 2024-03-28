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
    //    @Published var ticker: [Ticker] = []
    //    @Published var mainData: [mainViewData] = []
    
    var lastDate: Date?
    //    var price = ""
    
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
    
    func requestAPI() {
        guard let marketURL = URL(string: "https://api.upbit.com/v1/market/all") else {
            print("url 오류")
            return
        }
        URLSession.shared.dataTask(with: marketURL) { data, _, error in
            guard let data else {
                print("데이터 응답값 확인 필요")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Market].self, from: data)
                
                DispatchQueue.main.async {
                    self.market = decodedData.filter { $0.market.contains("KRW") }
                    print(self.market.count)
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getPrice(_ market: String) {
        UpbitPriceAPI.shared.requestPrice(market) { value in
            DispatchQueue.main.async {
                self.price = "\(value)원"
            }
        }
        //        UpbitPriceAPI.shared.requestPrice(market) { value in
        //            self.price = value
        //        }
        
        //        guard let url = URL(string: "https://api.upbit.com/v1/ticker?markets=\(market)") else {
        //            return
        //        }
        //
        //
        //        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        //
        //        if let date = lastDate, date.timeIntervalSinceNow < -7200 {
        //            request.cachePolicy = .reloadIgnoringLocalCacheData
        //            lastDate = Date()
        //        } else {
        //            request.cachePolicy = .returnCacheDataElseLoad
        //        }
        //
        //        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        //
        //        session.dataTask(with: request).resume()
        //    }
        //
    }
}
