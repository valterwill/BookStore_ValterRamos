//
//  GetBooksCall.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 08/07/21.
//

import Foundation

struct GetBooksResponse: Decodable {
    var kind: String
    var totalItems: Int
    var items: [Volume]?
}

class GetBooksCall: Call<GetBooksResponse> {
  public init(query: String, maxResults: Int, startIndex: Int) {
        
        let parameters: [String : Any] = [
          "q": query,
          "maxResults": maxResults,
          "startIndex": startIndex
        ]
        
        super.init(withParameters: parameters)
    }

    override public var endpoint: String {
        return "/books/v1/volumes"
    }
}
