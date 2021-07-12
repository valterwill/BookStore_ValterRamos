//
//  BookStore.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 08/07/21.
//

import Foundation

public enum BookStore {
    public static var environment: BookStore.Environment = .production
    
    public static var errorHandler: (Swift.Error?) -> Void = { _ in }
    
    public static var baseURL: String {
        return self.environment.rawValue
    }
    
    public static let responseQueue: DispatchQueue = DispatchQueue(label: "itservice.BookStore.responseQueue")
  
    public enum Result<T> {
        case success(T, Data)
        case failure(BookStore.Error)
        
        public func then<U>(next: (T?) -> Result<U>) -> Result<U> {
            return next(self.response)
        }
        
        public var response: T? {
            switch self {
            case .success(let response, _):
                return response
            case .failure(_):
                return nil
            }
        }
        
        public var data: Data? {
            switch self {
            case .success(_, let data):
                return data
            case .failure(_):
                return nil
            }
        }
        
        public var error: BookStore.Error? {
            switch self {
            case .success(_, _):
                return nil
            case .failure(let error):
                return error
            }
        }
    }
  
    public enum Error: Swift.Error, LocalizedError {
        case invalidParameters
        case requestError(Swift.Error?)
        case receivedNoData
        case failedToSerializeData
        case noInternetConnection(Swift.Error?)
        case nsUrlErrorReturned(Int)
        case httpStatusCode(Int)
        case invalidResult(Int, String?)

        static func fromSwiftError(error: Swift.Error?) -> BookStore.Error {
            guard (error as NSError?)?.code != -1009 else {
                return .noInternetConnection(error)
            }

            if (error as NSError?)?.domain == NSURLErrorDomain, let errorCode = (error as NSError?)?.code {
                return .nsUrlErrorReturned(errorCode)
            } else {
                return .requestError(error)
            }
        }

        public var errorDescription: String? {
            switch self {
            case .invalidParameters:
                return "Parâmetros inválidos."
            case .requestError(let error):
                return String(format: "Erro desconhecido na requisição. (%i)", (error as NSError?)?.code ?? -1)
            case .receivedNoData:
                return "O servidor não retornou dados."
            case .failedToSerializeData:
                return "Falha ao serializar dados de resposta."
            case .noInternetConnection(let error):
                return String(format: "Erro com a conexão de internet. (%i)", (error as NSError?)?.code ?? -1)
            case .nsUrlErrorReturned(let errorCode):
                return self.messageForNSURLErrorCode(errorCode: errorCode)
            case .httpStatusCode(let statusCode):
                return String(format: "HTTP Status Code: %i", statusCode)
            case .invalidResult(let result, let message):
                return String(format: "Servidor retornou resultado inválido: %i.\nMensagem: %@", result, message ?? "<null>")
            }
        }
        
        func messageForNSURLErrorCode(errorCode: Int) -> String {
            switch errorCode {
            case NSURLErrorTimedOut:
                return "NSURLError: Timeout"
            case NSURLErrorBadURL:
                return "NSURLError: Bad URL"
            case NSURLErrorUnsupportedURL:
                return "NSURLError: Unsupported URL"
            case NSURLErrorCannotFindHost:
                return "NSURLError: Cannot Find Host"
            case NSURLErrorCannotConnectToHost:
                return "NSURLError: Cannot Connect To Host"
            case NSURLErrorDataLengthExceedsMaximum:
                return "NSURLError: Data Length Exceeds Maximum"
            case NSURLErrorNetworkConnectionLost:
                return "NSURLError: Network Connection Lost"
            case NSURLErrorDNSLookupFailed:
                return "NSURLError: DNS Lookup Failed"
            case NSURLErrorHTTPTooManyRedirects:
                return "NSURLError: HTTP Too Many Redirects"
            case NSURLErrorResourceUnavailable:
                return "NSURLError: Resource Unavailable"
            case NSURLErrorNotConnectedToInternet:
                return "NSURLError: Not Connected To Internet"
            case NSURLErrorRedirectToNonExistentLocation:
                return "NSURLError: Redirect To Non Existent Location"
            case NSURLErrorBadServerResponse:
                return "NSURLError: Bad Server Response"
            case NSURLErrorUserCancelledAuthentication:
                return "NSURLError: User Cancelled Authentication"
            case NSURLErrorUserAuthenticationRequired:
                return "NSURLError: User Authentication Required"
            case NSURLErrorZeroByteResource:
                return "NSURLError: Zero Byte Resource"
            case NSURLErrorCannotDecodeRawData:
                return "NSURLError: Cannot Decode Raw Data"
            case NSURLErrorCannotDecodeContentData:
                return "NSURLError: Cannot Decode Content Data"
            case NSURLErrorCannotParseResponse:
                return "NSURLError: Cannot Parse Response"
            case NSURLErrorInternationalRoamingOff:
                return "NSURLError: International Roaming Off"
            case NSURLErrorCallIsActive:
                return "NSURLError: Call Is Active"
            case NSURLErrorDataNotAllowed:
                return "NSURLError: Data Not Allowed"
            case NSURLErrorRequestBodyStreamExhausted:
                return "NSURLError: Request Body Stream Exhausted"
            case NSURLErrorFileDoesNotExist:
                return "NSURLError: File Does Not Exist"
            case NSURLErrorFileIsDirectory:
                return "NSURLError: File Is Directory"
            case NSURLErrorNoPermissionsToReadFile:
                return "NSURLError: No Permissions To Read File"
            case NSURLErrorSecureConnectionFailed:
                return "NSURLError: Secure Connection Failed"
            case NSURLErrorServerCertificateHasBadDate:
                return "NSURLError: Server Certificate Has Bad Date"
            case NSURLErrorServerCertificateUntrusted:
                return "NSURLError: Server Certificate Untrusted"
            case NSURLErrorServerCertificateHasUnknownRoot:
                return "NSURLError: Server Certificate Has Unknown Root"
            case NSURLErrorServerCertificateNotYetValid:
                return "NSURLError: Server Certificate Not Yet Valid"
            case NSURLErrorClientCertificateRejected:
                return "NSURLError: Client Certificate Rejected"
            case NSURLErrorClientCertificateRequired:
                return "NSURLError: Client Certificate Required"
            case NSURLErrorCannotLoadFromNetwork:
                return "NSURLError: Cannot Load From Network"
            case NSURLErrorCannotCreateFile:
                return "NSURLError: Cannot Create File"
            case NSURLErrorCannotOpenFile:
                return "NSURLError: Cannot Open File"
            case NSURLErrorCannotCloseFile:
                return "NSURLError: Cannot Close File"
            case NSURLErrorCannotWriteToFile:
                return "NSURLError: Cannot Write To File"
            case NSURLErrorCannotRemoveFile:
                return "NSURLError: Cannot Remove File"
            case NSURLErrorCannotMoveFile:
                return "NSURLError: Cannot Move File"
            case NSURLErrorDownloadDecodingFailedMidStream:
                return "NSURLError: Download Decoding Failed Mid Stream"
            case NSURLErrorDownloadDecodingFailedToComplete:
                return "NSURLError: Download Decoding Failed To Complete"
            case NSURLErrorUnknown:
                return "NSURLError: Unknown"
            default:
                return "NSURLError: Unknown (1)"
            }
        }
    }
}

extension BookStore {
    public enum Environment: String {
        case production  = "https://www.googleapis.com"
    }
    static let query: String = "ios"
    static let maxResult: Int = 40
}
