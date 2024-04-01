//
//  ContentViewModel.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var market: [Market] = [Market(market: "마켓", korean: "한국어", english: "영어")]
    
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
                }
                
            } catch {
                print("&&&&&&&&&&&&", error)
            }
        }.resume()
    }
}
