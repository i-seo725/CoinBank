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
    @State private var isHidden = true
    
    var body: some View {
        VStack {
            Button(action: {
                isHidden.toggle()
                let name = isHidden ? "목록에서 코인 선택" : korean
                MainView.coinName = name
            }, label: {
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
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
            })
            .foregroundStyle(.black)
            .onAppear {
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
                .fill(.coral)
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(.white)
                VStack {
                    infoLine(title: "24시간 누적 거래대금:", second: "100,234,221", time: "")
                    infoLine(title: "24시간 누적 거래량:", second: "149,130", time: "")
                    lineView()
                    infoLine(title: "52주 신고가:", second: "9,000", time: "2024/09/12")
                    infoLine(title: "52주 신저가:", second: "2,000", time: "2024/09/12")
                    infoLine(title: "시가", second: "133,090", time: "")
                    infoLine(title: "종가", second: "384,111", time: "")
                    lineView()
                    infoLine(title: "최근 거래량:", second: "10만개", time: "12:01:55")
                    infoLine(title: "현재가", second: "123,112", time: "")
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 6)
        }
    }
}

//#Preview {
//    listView(korean: "ddd", english: "d", market: "krw-btc", viewModel: CoinListViewModel())
//}
