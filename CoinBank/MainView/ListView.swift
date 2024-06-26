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
    @StateObject var viewModel = CoinListViewModel()
    @State private var code: String = ""
    @State private var isHidden = true
    @State private var isLiked = false
    @State private var imageName = "star"
    @Binding var coinName: String
    
    var body: some View {
        VStack {
            Button(action: {
                isHidden.toggle()
                coinName = isHidden ? "코인 선택으로\n상세 정보 확인" : korean
                code = market
//                isHidden ? viewModel.closeWebSocket() : viewModel.fetchTicker(market)
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(korean)
                            .font(.subheadline)
                            .bold()
                        Text("\(english) / \(market)")
                            .font(.caption)
                    }
                    Spacer()
                    Text("\(viewModel.price)")
                        .font(.system(size: 13))
                    likedCoin()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
            })
            .foregroundStyle(.black)
            .task {
                viewModel.getPrice(market)
            }
            if !isHidden {
                infoBox()
            }
        }
        
    }
    
    func customText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14))
    }
    
    func infoLine(title: String, second: String, time: String) -> some View {
        HStack {
            customText(title)
            customText(second)
            Spacer()
            customText(time)
        }
    }
    
    func lineView() -> some View {
        Rectangle()
            .foregroundStyle(.coral)
            .frame(height: 1)
            .padding(.vertical, 2)
    }
    
    func infoBox() -> some View {
            ZStack {
                    RoundedRectangle(cornerRadius: 6)
                    .stroke()
                    .foregroundStyle(.coral)
                VStack {
                    infoLine(title: "24시간 누적 거래대금:", second: viewModel.tickerData.price24h, time: "")
                    infoLine(title: "24시간 누적 거래량:", second: viewModel.tickerData.volume24h, time: "")
                    lineView()
                    infoLine(title: "52주 최고가:", second: viewModel.tickerData.highestPrice, time: viewModel.tickerData.highestDate)
                    infoLine(title: "52주 최저가:", second: viewModel.tickerData.lowestPrice, time: viewModel.tickerData.lowestDate)
                    infoLine(title: "시가:", second: viewModel.tickerData.openingPrice, time: "")
                    infoLine(title: "종가:", second: viewModel.tickerData.closingPrice, time: "")
                    lineView()
                    infoLine(title: "최근 거래량:", second: viewModel.tickerData.tradeVolume, time: viewModel.tickerData.tradeTime)
                    infoLine(title: "현재가:", second: viewModel.tickerData.tradePrice, time: "")
                    lineView()
                    navLink()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            .onAppear {
                viewModel.fetchTicker(market)
            }
            .onDisappear {
                viewModel.closeWebSocket()
                isHidden = true
                coinName = "코인 선택으로\n상세 정보 확인"
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 6)
    }
    
    func navLink() -> some View {
        HStack {
            NavigationLink {
                ChartView(market: $code)
            } label: {
                HStack {
                    Image(systemName: "arrowshape.right.circle")
                        .tint(.coral)
                        .offset(x: 4)
                    Text("실시간 차트 보기")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundStyle(.coral)
                }
            }
            Spacer()
        }
    }
    
    func likedCoin() -> some View {
        
        Button(action: {
            isLiked.toggle()
            imageName = isLiked ? "star.fill" : "star"
            
            if isLiked {
                if let list = Coin.code {
                    var coins = list
                    coins.append(market)
                    Coin.code = coins
                } else {
                    Coin.code = [market]
                }
            } else {
                if let index = Coin.code?.firstIndex(of: market) {
                    Coin.code?.remove(at: index)
                }
            }
        }, label: {
            Image(systemName: imageName)
                .foregroundStyle(.coral)
        })
        .onAppear {
            if let _ = Coin.code?.firstIndex(of: market) {
                isLiked = true
                imageName = "star.fill"
            } else {
                isLiked = false
                imageName = "star"
            }
        }
    }
}

#Preview {
    listView(korean: "ddd", english: "d", market: "KRW-BTC", viewModel: CoinListViewModel(), coinName: .constant("리플"))
}
