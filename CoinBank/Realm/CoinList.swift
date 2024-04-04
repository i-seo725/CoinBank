//
//  CoinList.swift
//  CoinBank
//
//  Created by 이은서 on 4/4/24.
//

import Foundation
import RealmSwift

class CoinList: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var code: String
    @Persisted var korean: String
    @Persisted var english: String
    @Persisted var price: String
    @Persisted var date: Date
    @Persisted var isLiked: Bool
    
    convenience init(code: String, korean: String, english: String, price: String) {
        self.init()
        self.code = code
        self.korean = korean
        self.english = english
        self.price = price
        self.date = setDate()
        self.isLiked = false
    }
    
    func setDate() -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
        guard let result = formatter.date(from: "\(Date())") else { return Date() }
        return result
    }
}
