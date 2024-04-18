//
//  ContentView.swift
//  CoinBank
//
//  Created by 이은서 on 3/21/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var coinName = "코인 선택으로\n상세 정보 확인"
    @State private var market = ""
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                bannerView("즐겨찾는 코인 목록")
                    .padding(.horizontal, 8)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.liked, id: \.hashValue) { item in
                            listView(korean: item.korean, english: item.english, market: item.market, coinName: $coinName)
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .onAppear {
                    viewModel.requestAPI()
                    print("??", Coin.code)
                    print(viewModel.liked)
                }
                .navigationTitle("Watchlist")
            }
            .tabItem {
                VStack {
                    Image(systemName: "star.fill")
                    Text("즐겨찾기")
                }
            }
            NavigationStack {
                bannerView("전체 코인 목록")
                    .padding(.horizontal, 8)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.market, id: \.hashValue) { item in
                            listView(korean: item.korean, english: item.english, market: item.market, coinName: $coinName)
                        }
                    }
                    .task {
                        viewModel.requestAPI()
                    }
                    .padding(.horizontal, 12)
                    .scrollIndicators(.automatic)
                    .refreshable { //당겨서 새로고침
                        
                    }
                    .navigationTitle("Coin List")
                }
            }
            .tabItem {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("전체 보기")
                }
            }
        }
        .tint(.coral)
        
        
    }
    
    
    func bannerCircle(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .scaleEffect(1.4)
    }
    
    func bannerView(_ info: String) -> some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.coral)
                .overlay {
                    bannerCircle(.peach)
                        .offset(x: 0, y: -43)
                    bannerCircle(.coral)
                        .offset(x: 0, y: -58)
                    Text(info)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(maxWidth: .infinity)
                .frame(height: 170)
            Text(coinName)
                .multilineTextAlignment(.center)
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .lineLimit(2)
                
        }
    }
    
    //geometryProxy: 컨테이너 뷰에 대한 좌표나 크기에 접근
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let result = proxy.bounds(of: .scrollView)?.minX ?? 0 //x축 제일 앞에서 멈추겠다
        return -result  //사각형 크기에 들어가게 하려고 음수로 전환
    }
}

#Preview {
    MainView()
}
