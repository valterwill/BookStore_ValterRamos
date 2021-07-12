//
//  Service.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 08/07/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol _IService {
    func fetch<T>(_ call: Call<T>) -> Observable<(response: HTTPURLResponse, data: Data)>
    func serialize<T>(response: Observable<(response: HTTPURLResponse, data: Data)>, call: Call<T>) -> Observable<T>
    func execute<T>(_ call: Call<T>) -> Observable<T>
}

extension _IService {

    func fetch<T>(_ call: Call<T>) -> Observable<(response: HTTPURLResponse, data: Data)> where T : Decodable {
        if let request = call.bundle() {
            return URLSession.shared.rx.response(request: request)
                .catchError({ error in
                    
                    let error = BookStore.Error.fromSwiftError(error: error)
                    BookStore.errorHandler(error)
                    throw error
                })
        } else {
            
            let error = BookStore.Error.invalidParameters
            BookStore.errorHandler(error)
            return Observable.error(error)
        }
    }

    func serialize<T>(response: Observable<(response: HTTPURLResponse, data: Data)>, call: Call<T>) -> Observable<T> {
        return response.map({ response, data -> T in
            if !(200..<300 ~= response.statusCode) {
                let error = BookStore.Error.httpStatusCode(response.statusCode)
                BookStore.errorHandler(error)
                throw error
            } else {
                if let serialized = call.responseFrom(data: data) {
                    return serialized
                } else {
                    
                    let error = BookStore.Error.failedToSerializeData
                    BookStore.errorHandler(error)
                    throw error
                }
            }
        })
    }

    func execute<T>(_ call: Call<T>) -> Observable<T> {
        let fetch = self.fetch(call)
        return self.serialize(response: fetch, call: call)
    }
}

extension BookStore {
    typealias IService = _IService

    class RemoteService: BookStore.IService {
        public init() { }
    }
}
