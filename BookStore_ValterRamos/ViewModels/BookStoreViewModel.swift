//
//  BookStoreViewModel.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 07/07/21.
//

import Foundation
import RxCocoa
import RxSwift

class BookStoreViewModel {
  
  //MARK: - Variables
  private var _errorRelay = PublishRelay<Swift.Error>()
  var errorRelay: Observable<Swift.Error> {
      return self._errorRelay.asObservable()
  }
  
  private var _books = PublishRelay<([Volume])>()
  public var books: Observable<([Volume])> {
      return self._books.map({ $0 }).asObservable()
  }
  
  private var disposeBag = DisposeBag()
  
  let volumeRepository: Repository
  
  init(volumeRepository: Repository = VolumeRepository()) {
      self.volumeRepository = volumeRepository
  }
  
  //MARK: - Fetch Logic
  func fetchStoredVolumes() -> [Volume]{
    return self.volumeRepository.getVolumes()
  }
  
  func fetchBooks(query: String, maxResults: Int, startIndex: Int) {
      
      let bookStoreWorker = BookStoreWorker()
      
      let observable = bookStoreWorker.fetchBooks(query: query, maxResults: maxResults, startIndex: startIndex)
      
      observable
          .subscribe(onNext: {
              self._books.accept($0)
          }, onError: { (error) in
              self._errorRelay.accept(error)
          })
          .disposed(by: self.disposeBag)
  }
}
