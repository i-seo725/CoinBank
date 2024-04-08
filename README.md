## CoinPocket - 관심가는 코인 실시간 트래킹
<img width="1018" alt="스크린샷 2023-11-12 오전 10 55 52" src="https://github.com/i-seo725/PodoTodo/assets/140357379/901e9bd8-1d6f-4dd6-bd61-eb324756a777">


## 앱 소개
 * 매일 그날의 할 일을 모두 완료하면 포도알 스티커를 하나씩 채워 성취감을 느낄 수 있도록 도와주는 앱
 * 테이블뷰 셀을 좌우로 스와이프하여 완료/취소, 삭제, 미루기 기능 동작
<br/>


## 주요 기능
 * 사용자가 즐겨찾기한 코인을 UserDefaults에 저장하여 별도 관리
 * WebSocket 통신으로 사용자가 선택한 코인에 대해 최근 거래량 및 현재가 등의 실시간 상세 정보 제공
 * Upbit API를 활용하여 실시간으로 변동하는 호가에 대한 차트 그래프 제공
 <br/>

## 개발 기간
 * 2024.04.01.~ 2024.04.06. (6일)
<br/>


## 개발환경
  * Xcode 15.2
  * Supported Destinations : iPhone
  * Minimum Deployments : 17.0
  * Orientation : Portrait
<br/>


## 사용기술 및 라이브러리
 * SwiftUI, MVVM, Combine, UserDefaults
 * Upbit RestAPI/WebSocket
 <br/>
 
## 트러블 슈팅     
 ### 1. 전체 코인 목록의 현재가를 불러올 때 과도한 API 콜 발생
   * 배열에 전체 코인의 현재가를 저장하려다보니 뷰에 표시되지 않는 항목에 대해서도 API 요청이 필요하게 되어 불필요한 트래픽 발생
   * 각각의 리스트 항목에 대한 view를 별도 구조체로 만들어 해당 구조체에서 네트워크 요청을 시도하고 LazyVStack으로 필요할 때 로드되도록 변경
     ```swift
     struct ListView: View {
       var body: some View {
          VStack {
              Button(action: {
                  ...
              }, label: {
                  ...
              })
              .foregroundStyle(.black)
              .onAppear {
                  viewModel.getPrice(market)
              }
          }
      }

     struct MainView: View {
       var body: some View {
         LazyVStack {
           ForEach(viewModel.market, id: \.hashValue) { item in
             listView(korean: item.korean, english: item.english, market: item.market, coinName: $coinName)
           }
        }
       }
     }
     ```
   
 ### 2. WebSocket 통신 시 응답값에 따른 뷰 변동 이슈
   * 코인의 상세 정보 및 그래프를 표현할 때 WebSocket 응답값이 실시간으로 반영되어야 하는데 변동되지 않는 이슈 발생
   * 지속적으로 들어오는 응답값을 한번만 처리하여 발생된 이슈로 추측, combine을 활용하여 방출되는 매 이벤트에 반응하도록 설계
     ```swift
      CoinOrderBookWebSocketManager.shared.response
            .receive(on: DispatchQueue.main)
            .sink { orderBook in
                let result = orderBook.units
                let ask = result.map { OrderBookItem(price: $0.askPrice, size: $0.askSize) }.sorted(by: { $0.price > $1.price })
                let bid = result.map { OrderBookItem(price: $0.bidSize, size: $0.bidSize) }.sorted(by: { $0.price > $1.price} )
                
                self.askOrderBook = ask
                self.bidOrderBook = bid
            }
            .store(in: &cancellable)
     ```

<br/>

## 회고
 * 효율적인 메모리 관리를 위해 Realm을 Singleton 패턴으로 구성하였으나 충돌이 발생할 수 있다는 사실을 추후에 알게되어 출시 후 업데이트에 반영하게 됨
   테스트 시에는 충돌이 발생하지 않았으나 출시 후 Firebase Crashlytics에서 관찰된 충돌 로그의 원인으로 추측됨
 * 학습 시에는 열거형의 편의성을 크게 이해하지 못하였으나 앱 출시 후 유지보수 측면에서 매우 편리함을 이해하여 적극 활용하게 됨
 * 포도알 채우기 로직의 경우 do try catch 문을 활용할 수도 있었을 것 같았는데 if else문만 사용한 점에 아쉬움이 남아 코드 개선 및 추가 학습 예정
