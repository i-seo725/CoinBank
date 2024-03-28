//
//  CoinListView.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import SwiftUI

struct CoinListView: View {
    
    @StateObject var viewModel = CoinListViewModel()
    
    var body: some View {
        LazyVStack {
            ForEach(viewModel.market, id: \.hashValue) { item in
                listView(korean: item.korean, english: item.english, market: item.market)
            }
        }
        .onAppear {
            viewModel.requestAPI()
        }
    }
}

#Preview {
    CoinListView()
}
