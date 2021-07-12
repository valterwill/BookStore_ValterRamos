//
//  BookStore.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import Foundation
import Realm
import RealmSwift

class Book: Object, Decodable {
    @objc dynamic var title: String = ""
    @objc dynamic var subtitle: String  = ""
    var authors = List<String>()
    @objc dynamic var desc: String  = ""
    @objc dynamic var thumbnail: String = ""
  
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case authors
        case desc = "description"
        case imageLinks
        case thumbnail
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
        authors = try container.decodeIfPresent(List<String>.self, forKey: .authors) ??  List<String>()
        desc = try container.decodeIfPresent(String.self, forKey: .desc) ?? ""
        let imageLinks = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
        thumbnail = try imageLinks?.decodeIfPresent(String.self, forKey: .thumbnail) ?? ""
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
