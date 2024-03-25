//
//  ListViewModel.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation

class CoinListViewModel: ObservableObject {
    
    @Published var market: [Market] = [Market(market: "마켓", korean: "한국어", english: "영어")]
    
    func requestAPI() {
        market = [Market(market: "2", korean: "11", english: "s"), Market(market: "@@@", korean: "DDS", english: "KKK"), Market(market: "ASDFC", korean: "c", english: "9")]
        guard let url = URL(string: "https://api.upbit.com/v1/market/all") else {
            print("url 오류")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print("데이터 응답값 확인 필요: ", error)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Market].self, from: data)
                DispatchQueue.main.async {
                    self.market = decodedData
                }
                
            } catch {
                print(error)
            }
        }.resume()
        
    }
}
