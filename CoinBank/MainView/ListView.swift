//
//  ListView.swift
//  CoinBank
//
//  Created by 이은서 on 3/26/24.
//

import SwiftUI


struct listView: View {
    
    var korean: String
    var english: String
    var market: String
    @ObservedObject var viewModel = CoinListViewModel()
    
    var body: some View {
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
            Text("\(viewModel.price)")
                .font(.system(size: 13))
        }
        .onAppear {
            viewModel.getPrice(market)
        }

    }
    
}

#Preview {
    listView(korean: "ddd", english: "d", market: "krw-btc", viewModel: CoinListViewModel())
}
