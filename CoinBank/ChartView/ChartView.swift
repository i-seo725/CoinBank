//
//  ChartView.swift
//  CoinBank
//
//  Created by 이은서 on 3/27/24.
//

import SwiftUI

struct ChartView: View {
    
    @Binding var market: String
    @StateObject private var viewModel = ChartViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GeometryReader { proxy in
                    let graphWidth = proxy.size.width * 0.7 //차트 최대 너비
                    
                    VStack {
                        HStack {
                            Text("매도 호가")
                                .font(.headline)
                            Spacer()
                            Text("매도 잔량")
                                .font(.headline)
                                .padding(.leading, 10)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        ForEach(viewModel.askOrderBook, id: \.id) { item in
                            HStack {
                                Text("\(item.price.formatted())")
                                    .font(.system(size: 14))
                                    .frame(width: proxy.size.width * 0.2)
                                ZStack {
                                    ZStack(alignment: .leading) {
                                        let graphSize = item.size / viewModel.largestAskSize() * graphWidth
                                        Capsule()
                                            .foregroundStyle(.lightPink)
                                            .frame(maxWidth: .infinity)
                                        Capsule()
                                            .frame(width: graphSize)
                                            .foregroundStyle(.coral)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.trailing, 4)
                                    
                                    Text(item.size.formatted())
                                }
                            }
                            .frame(height: 34)
                            .padding(.horizontal, 8)
                        }
                    }
                }
            }
            .navigationTitle("실시간 호가")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.fetchOrderBook(market)
        }
        .onDisappear {
            viewModel.closeWebSocket()
        }
    }
}

#Preview {
    ChartView(market: .constant("KRW-BTC"))
}
