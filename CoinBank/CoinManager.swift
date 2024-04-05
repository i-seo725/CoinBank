//
//  UserDefaultsManager.swift
//  CoinBank
//
//  Created by 이은서 on 4/4/24.
//

import Foundation

@propertyWrapper
struct CoinManager {
    
    let key: String
    
    var wrappedValue: [String]? {
        get {
            UserDefaults.standard.stringArray(forKey: key)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

enum Coin {
    
    enum Key: String {
        case code
    }
    
    @CoinManager(key: Key.code.rawValue)
    static var code
}
