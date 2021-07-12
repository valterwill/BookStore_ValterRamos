//
//  BookStoreViewModel.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 07/07/21.
//

import Foundation
import RxCocoa
import RxSwift

class BookDetailViewModel {
  
  //MARK: - Variables
  var volume: Volume?
  let volumeRepository: Repository
  
  init(volumeRepository: Repository = VolumeRepository()) {
      self.volumeRepository = volumeRepository
  }
  
  func isFavorite() -> Bool {
    guard let volume = self.volume else { return false}
    guard let volumeStored = volumeRepository.getVolume(withVolumeId: volume.id) else { return false }
    return !volumeStored.deleted
  }
  
  func toogleFavorite() -> Bool {
    guard let volume = self.volume else { return false}
    let isFavorite = self.isFavorite()
    if(isFavorite) {
      volumeRepository.delete(withVolumeId: volume.id)
    } else {
      volumeRepository.save(volume: volume)
    }
    return !isFavorite
  }
}
