//
//  ChartView.swift
//  CoinBank
//
//  Created by 이은서 on 3/27/24.
//

import SwiftUI

struct ChartView: View {
    
    let market: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GeometryReader { proxy in
                    
                    let graphWidth = proxy.size.width * 0.7 //차트 최대 너비
                    
                    VStack {
                        ForEach(1..<10, id: \.self) { item in
                            HStack {
                                Text("테스트 중 - \(item)")
                                    .font(.system(size: 14))
                                    .frame(width: proxy.size.width * 0.2)
                                ZStack(alignment: .leading) {
                                    
                                    Capsule()
                                        .foregroundStyle(.lightPink)
                                        .frame(maxWidth: .infinity)
                                    Capsule()
                                        .foregroundStyle(.coral)
                                        .frame(width: CGFloat.random(in: 20...240), alignment: .leading)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.trailing, 4)
                            }
                            .frame(height: 36)
                            .padding(.horizontal, 8)
                        }
                    }
                    
                }
            }
            .navigationTitle("실시간 호가")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
//            WebSocketManager.shared.openWebSocket()
//            WebSocketManager.shared.send()
        }
    }
}

#Preview {
    ChartView(market: "")
}
