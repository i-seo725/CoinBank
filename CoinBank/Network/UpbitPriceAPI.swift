//
//  UpbitAPI.swift
//  CoinBank
//
//  Created by 이은서 on 3/28/24.
//

import Foundation

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
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
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
                        handler(self.price + "원")
                    }
                }
                
            } catch {
                print("###########", response)
                handler("확인 중...")
            }
        }.resume()
    }
}

extension UpbitPriceAPI: URLSessionDataDelegate { }
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        
//        do {
//            let decodedData = try JSONDecoder().decode([Ticker].self, from: data)
//            if let data = decodedData.first {
//                    let formatter = NumberFormatter()
//                    formatter.numberStyle = .decimal
//                    price = formatter.string(for: data.price) ?? "0"
//            }
//            
//        } catch {
//            print("###########")
//            price = "확인 중..."
//        }
//        print("@@#$", price)
//    }
//    
//    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse) async -> CachedURLResponse? {
//        print(proposedResponse.storagePolicy)
//        return .some(.init(response: <#T##URLResponse#>, data: <#T##Data#>))
//    }
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
//        
//        guard let url = proposedResponse.response.url else {
//            completionHandler(nil)
//            return
//        }
//
//        if url.scheme == "https" {
//            print("@@@@@@@@@@@@@@@@@@")
//            let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .allowedInMemoryOnly)
//            completionHandler(response)
//        } else {
//            print("###############################")
//            let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .notAllowed)
//            completionHandler(response)
//        }
//    }
//    
//}
