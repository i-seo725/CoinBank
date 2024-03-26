//
//  ListViewModel.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation

class CoinListViewModel: ObservableObject {
    
    @Published var market: [Market] = [Market(market: "마켓", korean: "한국어", english: "영어")]
//    @Published var ticker: [Ticker] = []
//    @Published var mainData: [mainViewData] = []
    
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
    
    func requestPrice(_ market: String) -> String {
        var result = "0"
//        var url = URLComponents(string: "https://api.upbit.com/v1/ticker?")
//        let query = URLQueryItem(name: "markets", value: market)
//        url?.queryItems?.append(query)

//        guard let url = url?.url else {
//            print("url 오류")
//            return result
//        }

        guard let url = URL(string: "https://api.upbit.com/v1/ticker?markets=krw-btc") else {
            return ""
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("@@@", error)
                return
            }
            
            guard let data else {
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Ticker].self, from: data)
                print(decodedData)
//                if let data = decodedData.first {
//                    
//                    DispatchQueue.main.async {
//                        let formatter = NumberFormatter()
//                        formatter.numberStyle = .decimal
//                        result = formatter.string(for: data.price) ?? "0"
//                    }
//                }
                
            } catch {

                print("###########", response)
            }
        }.resume()
        
        return result
    }
}
