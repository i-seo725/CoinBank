//
//  ContentView.swift
//  CoinBank
//
//  Created by 이은서 on 3/21/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var coinName = "코인 선택"
    @State private var market = ""
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            bannerView()
                .padding(.horizontal, 8)
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.market, id: \.hashValue) { item in
                        listView(korean: item.korean, english: item.english, market: item.market, coinName: $coinName)
                    }
                }
                .onAppear {
                    viewModel.requestAPI()
                }
                .padding(.horizontal, 12)
                .scrollIndicators(.automatic)
                .refreshable { //당겨서 새로고침
                    
                }
                .navigationTitle("Coin List")
                .navigationDestination(for: Int.self) { _ in
                    
                }
            }
        }
        
        
    }
    
    
    func bannerCircle(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .scaleEffect(1.2)
    }
    
    func bannerView() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.coral)
                .overlay {
                    bannerCircle(.peach)
                        .offset(x: 120, y: 150)
                    bannerCircle(.peach)
                        .offset(x: -120, y: 150)
                    bannerCircle(.peach)
                        .offset(x: 0, y: 150)
                    bannerCircle(.lightPink)
                        .offset(x: 120, y: 170)
                    bannerCircle(.lightPink)
                        .offset(x: -120, y: 170)
                    bannerCircle(.lightPink)
                        .offset(x: 0, y: 170)
                    Circle()
                        .fill(.peach)
                        .scaleEffect(1.2)
                        .offset(x: 0, y: -38)
                    Circle()
                        .fill(.coral)
                        .scaleEffect(1.2)
                        .offset(x: 0, y: -53)
                    Text("코인 정보 보기")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            Text(coinName)
                .font(.title)
                .bold()
                .foregroundStyle(.white)
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
