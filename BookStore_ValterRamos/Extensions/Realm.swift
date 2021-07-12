//
//  Realm.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 09/07/21.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }
