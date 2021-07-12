//
//  Call.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 08/07/21.
//

import Foundation
import Alamofire

class Call<T : Decodable> {

    public init(withParameters parameters: [String : Any]? = nil) {
        self.parameters = parameters ?? [:]
    }
    
    public var endpoint: String {
        return "/"
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public var fullURL: String {
        return String(format: "%@%@", BookStore.baseURL, self.endpoint)
    }

    public var parameters: [String : Any] = [:]
    private var request: DataRequest?

    private func setupResponseHandler(withCompletionHandler completionHandler: ((BookStore.Result<T>) -> Void)?) {
        guard let request = self.request else {
            fatalError("Tried to setup response handler for nil request")
        }

        request.validate().responseJSON(queue: BookStore.responseQueue, options: .allowFragments) { (dataResponse) in

            let statusCode = (dataResponse.response?.statusCode ?? 0)

            guard 200..<300 ~= statusCode else {
              completionHandler?(.failure(BookStore.Error.httpStatusCode(statusCode)))
                return
            }

            guard let data = dataResponse.data else {
              completionHandler?(.failure(BookStore.Error.receivedNoData))
                return
            }

            guard dataResponse.result.isSuccess else {
                let error = BookStore.Error.fromSwiftError(error: dataResponse.result.error)
                completionHandler?(.failure(error))
                return
            }
            
            if let json = dataResponse.result.value as? T {
                completionHandler?(.success(json, data))
            } else {
                if let decoded = self.responseFrom(data: data) {
                    completionHandler?(.success(decoded, data))
                } else {
                  completionHandler?(.failure(BookStore.Error.failedToSerializeData))
                }
            }
        }
    }

    internal func responseFrom(data: Data) -> T? {
        do {
            let decoder = JSONDecoder()

            decoder.keyDecodingStrategy = .custom { jsonKeys in
                let lastKey = jsonKeys.last!
                if lastKey.intValue != nil {
                    return lastKey
                }

                if lastKey.stringValue == lastKey.stringValue.uppercased() {
                    return lastKey
                }

                let firstLetter = lastKey.stringValue.prefix(1).lowercased()
                let modifiedKey = firstLetter + lastKey.stringValue.dropFirst()

                return AnyCodingKey(stringValue: modifiedKey)
            }
            
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch (let error) {
            print(error)
            return nil
        }
    }

    public func cancel() {
        self.request?.cancel()
    }

    public func bundle() -> URLRequest? {
        let url = URL(string: self.fullURL)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = self.parameters.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        if var request = try? URLRequest(url: urlComponents?.url! as! URLConvertible, method: self.method, headers: nil) {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }

        return nil
    }

    public func execute(completionHandler: ((BookStore.Result<T>) -> Void)?) {
        if let request = self.bundle() {
            self.request = BookStoreNetwork.default.defaultManager.request(request)
            self.setupResponseHandler(withCompletionHandler: completionHandler)
        } else {
            completionHandler?(.failure(.invalidParameters))
        }
    }
}
