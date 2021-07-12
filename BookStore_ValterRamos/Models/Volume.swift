//
//  BookStore.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import Foundation
import Realm
import RealmSwift

class Volume: Object, Decodable {
    @objc dynamic var id: String = ""
    @objc dynamic var volumeInfo: Book? = nil
    @objc dynamic var saleInfo: SaleInfo? = nil
    @objc dynamic var deleted: Bool = false
  
    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
        case saleInfo
    }
  
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        volumeInfo = try container.decode(Book.self, forKey: .volumeInfo)
        saleInfo = try container.decode(SaleInfo.self, forKey: .saleInfo)
        super.init()
    }
  
    required init() {
      super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
      super.init(realm: realm, schema: schema)
    }

    required init(value: Any, schema: RLMSchema) {
      super.init(value: value, schema: schema)
    }
}
