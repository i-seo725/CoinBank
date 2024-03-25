//
//  CoinListView.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import SwiftUI

struct CoinListView: View {
    
    @ObservedObject var viewModel = CoinListViewModel()
    
    var body: some View {
        LazyVStack {
            ForEach(viewModel.market, id: \.hashValue) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(item.korean)")
                            .font(.subheadline)
                            .bold()
                        Text(item.english)
                            .font(.caption)
                    }
                    Spacer()
                    Text(item.market)
                        .font(.system(size: 13))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
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
