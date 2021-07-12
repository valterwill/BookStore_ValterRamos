//
//  VolumeRepository.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 09/07/21.
//

import Foundation
import RealmSwift

class VolumeRepository: Repository {
  let realm = try! Realm()
  
  func save(volume: Volume) {
    try! self.realm.write {
      if let volumeStored = getVolume(withVolumeId: volume.id) {
        volumeStored.deleted = false
      } else {
        realm.add(volume)
      }
    }
  }
  
  func delete(withVolumeId volumeId: String) {
    guard let volume = getVolume(withVolumeId: volumeId) else { return }
    try! realm.write {
      volume.deleted = true
    }
  }
  
  func getVolume(withVolumeId volumeId: String) -> Volume? {
    return realm.objects(Volume.self).filter("id = '\(volumeId)'").first
  }
  
  func getVolumes() -> [Volume] {
    return realm.objects(Volume.self).filter("deleted = false").toArray()
  }
}
