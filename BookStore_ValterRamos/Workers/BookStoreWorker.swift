//
//  BookStoreWorker.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 08/07/21.
//

import Foundation

import RxCocoa
import RxSwift

class BookStoreWorker {
    
    
    private var disposeBag = DisposeBag()
    private var service: BookStore.IService
    
    //MARK: - Object Lifecycle
    public init(withService service: BookStore.IService = BookStore.RemoteService()) {
        self.service = service
    }

    //MARK: - Work Logic
    public func fetchBooks(query: String, maxResults: Int, startIndex: Int) -> Observable<[Volume]>  {
        
        let call = GetBooksCall(query: query, maxResults: maxResults, startIndex: startIndex)

        return self.service.execute(call)
            .map({
                if let items = $0.items {
                    return items
                } else {
                    throw BookStore.Error.invalidParameters
                }
            })
    }
}


