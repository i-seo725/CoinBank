////
////  ListView.swift
////  CoinBank
////
////  Created by 이은서 on 3/26/24.
////
//
//import SwiftUI
//
//
//struct ListView: View {
//    
//    @Binding var korean: String
//    @Binding var english: String
//    @Binding var market: String
//    @StateObject var viewModel = CoinListViewModel()
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(korean)
//                        .font(.subheadline)
//                        .bold()
//                }
//                Text("\(english) / \(market)")
//                    .font(.caption)
//            }
//            Spacer()
////            Text(viewModel.requestPrice(market))
////                .font(.system(size: 13))
//        }
//    }
//}
