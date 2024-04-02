//
//  WebSocketManager.swift
//  CoinBank
//
//  Created by 이은서 on 3/26/24.
//

import Foundation
import Combine

final class TickerWebSocketManager: NSObject {
    
    static let shared = TickerWebSocketManager()
    
    private override init() {
        super.init()
    }
    
    private var webSocket: URLSessionWebSocketTask?
    private var timer: Timer?
    private var isOpen = false
    
    var response = PassthroughSubject<Ticker, Never>()

    func openWebSocket() {
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            webSocket = session.webSocketTask(with: url)
            webSocket?.resume()
            
//            ping()
        }
    }
    
    //소켓 닫기 요청
    func closeWebSocket() {
        
        //URLSessionWebSocketTask Enum Close Code
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        
        timer?.invalidate()
        timer = nil
        
        isOpen = false
    }
    
    func tickerSend(_ ticker: String) {
        let request = """
        [{"ticket":"eunseo"},{"type":"ticker","codes":["\(ticker)"]}]
        """
        webSocket?.send(.string(request), completionHandler: { error in
            if let error {
                print("send error ", error)
            }
        })
    }
    
    func receive() {
        if isOpen { //소켓이 열린 상태에서만 데이터 받게 하기
            webSocket?.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let success):
                    switch success {
                    case .data(let data):
                        do {
                            let decodedData = try JSONDecoder().decode(Ticker.self, from: data)
                            self?.response.send(decodedData)
                            print(decodedData)
                            
                        } catch {
                            print(error)
                        }
                    case .string(let string):
                        print(string)
                    @unknown default:
                        print("unknown default")
                    }
                case .failure(let failure):
                    print(failure)
                }
                self?.receive()
            })
        }
        

    }
    
    private func ping() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error {
                    print("PingPong Error ", error)
                } else {
                    print("Ping")
                }
            })
        })
        
    }
    
}


extension TickerWebSocketManager: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("OPEN")
        isOpen = true
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isOpen = false
        print("CLOSE")
    }
    
    
}
