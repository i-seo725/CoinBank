//
//  CoinListView.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import SwiftUI

struct CoinListView: View {
    
    var viewModel = CoinListViewModel()
    
    var body: some View {
        LazyVStack {
            HStack {
                ForEach(viewModel.market, id: \.hashValue) { item in
                    VStack(alignment: .leading) {
                        Text(item.korean)
                            .font(.headline)
                        Text(item.english)
                            .font(.caption)
                    }
                    Spacer()
                    Text(item.market)
                        .bold()
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.requestAPI()
        }
    }
}

#Preview {
    CoinListView()
}
