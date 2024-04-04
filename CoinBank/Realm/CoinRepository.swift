//
//  CoinRepository.swift
//  CoinBank
//
//  Created by 이은서 on 4/4/24.
//

import Foundation
import RealmSwift

protocol RepositoryType: AnyObject {
    
    func fetch() -> Results<CoinList>
    func create(_ item: CoinList)
    func delete(_ item: CoinList)
}

final class CoinRepository: RepositoryType {
    
    private let realm = try! Realm()
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: ", version)
        } catch {
            print(error)
        }
    }
    
    func fetch() -> Results<CoinList> {
        let data = realm.objects(CoinList.self)
        return data
    }
    
    
    func create(_ item: CoinList) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func update(code: String, price: Int) {
        do {
            try realm.write {
                realm.create(CoinList.self, value: ["code": code, "price": price], update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func toggleLiked(code: String, isLiked: Bool) {
        do {
            try realm.write {
                realm.create(CoinList.self, value: ["code": code, "isLiked": isLiked], update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func delete(_ item: CoinList) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}
