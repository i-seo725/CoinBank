//
//  CoinListView.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import SwiftUI

struct CoinListView: View {
    
    @State private var korean: String = "2"
    @State private var english: String = "dd"
    @State private var market: String = "krw-btc"
    @StateObject var viewModel = CoinListViewModel()
    
    var body: some View {
        LazyVStack {
            ForEach(viewModel.market, id: \.hashValue) { item in
                listView(korean: item.korean, english: item.english, market: item.market)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
            }
        }
        .onAppear {
            viewModel.requestAPI()
        }
    }
    
    @ViewBuilder
    func listView(korean: String, english: String, market: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(korean)
                        .font(.subheadline)
                        .bold()
                }
                Text("\(english) / \(market)")
                    .font(.caption)
            }
            Spacer()
//            Text(viewModel.requestPrice(market))
//                .font(.system(size: 13))
        }
        .onAppear {
            
        }
    }

}

#Preview {
    CoinListView()
}
