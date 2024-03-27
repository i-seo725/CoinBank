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
            self.price = value
        }
    }
    
    
}

class UpbitPriceAPI: NSObject {
    
    static let shared = UpbitPriceAPI()
    private override init() { }
    var lastDate: Date?
    var price = ""
    
    func requestPrice(_ market: String, handler: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.upbit.com/v1/ticker?markets=\(market)") else {
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let date = lastDate, date.timeIntervalSinceNow < -7200 {
           request.cachePolicy = .reloadIgnoringLocalCacheData
           lastDate = Date()
        } else {
           request.cachePolicy = .returnCacheDataElseLoad
        }
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                if let data = decodedData.first {
                    
                    DispatchQueue.main.async {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        self.price = formatter.string(for: data.price) ?? "0"
                        handler(self.price)
                    }
                }
                
            } catch {
                print("###########", response)
                handler("확인 중")
            }
        }.resume()
    }
}

extension UpbitPriceAPI: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        
        guard let url = proposedResponse.response.url else {
            completionHandler(nil)
            return
        }

        if url.scheme == "https" {
            print("@@@@@@@@@@@@@@@@@@")
            let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .allowedInMemoryOnly)
            completionHandler(response)
        } else {
            print("###############################")
            let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .notAllowed)
            completionHandler(response)
        }
    }
}
