//
//  BookStore.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import Foundation
import Realm
import RealmSwift


class SaleInfo: Object, Decodable {
    @objc dynamic var saleability: String = ""
    @objc dynamic var isEbook: Bool = false
    @objc dynamic var price: Double = 0.0
    @objc dynamic var currencyCode: String? = nil
    @objc dynamic var buyLink: String? = nil
  
    enum CodingKeys: String, CodingKey {
        case saleability
        case isEbook
        case listPrice
        case price = "amount"
        case currencyCode
        case buyLink
    }
  
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        saleability = try container.decode(String.self, forKey: .saleability)
        isEbook = try container.decode(Bool.self, forKey: .isEbook)
        let listPrice = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .listPrice)
        price = try listPrice?.decode(Double.self, forKey: .price) ?? 0
        currencyCode = try listPrice?.decode(String.self, forKey: .currencyCode)
        buyLink = try? container.decode(String.self, forKey: .buyLink)
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
    
    func normalize() -> String? {
        guard let currencyCode = currencyCode else {
            return nil
        }
        let symbol = getSymbol(forCurrencyCode: currencyCode)!
        return "\(symbol)\(String(format: "%.2f", price))"
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
}
