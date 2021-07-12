//
//  BookStoreNetwork.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 08/07/21.
//

import Foundation
import Alamofire
import AlamofireImage

//MARK: - Calss
public class BookStoreNetwork {
    
    //MARK: - Object Lifecycle
    init() {
        self.defaultManager = Alamofire.SessionManager.default
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 500 * 1024 * 1024, diskPath: nil)
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        self.cachedManager = Alamofire.SessionManager(configuration: sessionConfiguration, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
    }
    
    //MARK: - Variables
    public static let `default` = BookStoreNetwork()
    public let cachedManager: Alamofire.SessionManager
    public let defaultManager: Alamofire.SessionManager
    
    
    //MARK: - Fetch Logic
    public func requestFirstValid(urls: [URLConvertible], completionHandler: ((UIImage?) -> Void)?) {

        func requestImageURL(atIndex index: Int) {
            guard urls.count > index else {
                return
            }

            let imageURL = urls[index]
            self.request(imageURL: imageURL) { (image) in
                if let image = image {
                    completionHandler?(image)
                } else {
                    if index < urls.count {
                        requestImageURL(atIndex: index + 1)
                    }
                }
            }
        }

        requestImageURL(atIndex: 0)
    }

    public func request(imageURL: URLConvertible, completionHandler: ((UIImage?) -> Void)?) {
        self.cachedManager.request(imageURL).responseData { (dataResponse) in
            if let data = dataResponse.value, let image = UIImage(data: data) {
                completionHandler?(image)
            } else {
                completionHandler?(nil)
            }
        }
    }
}
