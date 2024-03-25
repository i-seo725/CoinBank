//
//  ContentView.swift
//  CoinBank
//
//  Created by 이은서 on 3/21/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            bannerView()

        }
        .padding()
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
                Text("실시간 코인 정보 보기")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(maxWidth: .infinity)
            .frame(height: 200)
        
        VStack(alignment: .center) {
            Text("목록에서 코인 선택")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
        }
    }
}

//geometryProxy: 컨테이너 뷰에 대한 좌표나 크기에 접근
func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
    let result = proxy.bounds(of: .scrollView)?.minX ?? 0 //x축 제일 앞에서 멈추겠다
    return -result  //사각형 크기에 들어가게 하려고 음수로 전환
}


#Preview {
    ContentView()
}
