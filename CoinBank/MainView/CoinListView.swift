//
//  CoinListView.swift
//  CoinBank
//
//  Created by 이은서 on 3/25/24.
//

import SwiftUI

struct CoinListView: View {
    var body: some View {
        LazyVStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("한글 이름")
                        .font(.headline)
                    Text("영어 이름")
                        .font(.caption)
                }
                Spacer()
                Text("코인 단위")
                    .bold()
            }
            .padding()
        }
    }
}

#Preview {
    CoinListView()
}
