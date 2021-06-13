//
//  AFSessionManagerStub.swift
//  GithubSearchTests
//
//  Created by rowkaxl on 2021/06/13.
//

@testable import GithubSearch
@testable import Alamofire

final class AFSessionManagerStub: AFSessionManagerProtocol {
  
    /// Closure which provides a `URLRequest` for mutation.
//    typealias RequestModifier = (inout URLRequest) throws -> Void
    
    var requestParameters: (convertible: URLConvertible,
                            method: HTTPMethod,
                            parameters: Parameters?,
                            encoding: ParameterEncoding,
                            headers: HTTPHeaders?)?
    
    
    @discardableResult
    func request(_ convertible: URLConvertible,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      encoding: ParameterEncoding,
                      headers: HTTPHeaders?,
                      interceptor: RequestInterceptor?,
                      requestModifier: RequestModifier?) -> DataRequest {
        self.requestParameters = (convertible, method, parameters, encoding, headers)
        
        let convertible = RequestConvertible(url: convertible,
                                             method: method,
                                             parameters: parameters,
                                             encoding: encoding,
                                             headers: nil,
                                             requestModifier: nil)
        
        return DataRequest(convertible: convertible,
                           underlyingQueue: DispatchQueue.global(),
                           serializationQueue: DispatchQueue.global(),
                           eventMonitor: nil,
                           interceptor: nil,
                           delegate: self)
    }
}

extension AFSessionManagerStub: RequestDelegate {
    
    struct RequestConvertible: URLRequestConvertible {
        let url: URLConvertible
        let method: HTTPMethod
        let parameters: Parameters?
        let encoding: ParameterEncoding
        let headers: HTTPHeaders?
        let requestModifier: RequestModifier?

        func asURLRequest() throws -> URLRequest {
            var request = try URLRequest(url: url, method: method, headers: headers)
            try requestModifier?(&request)

            return try encoding.encode(request, with: parameters)
        }
    }
    
    var sessionConfiguration: URLSessionConfiguration {
        URLSessionConfiguration()
    }
    
    var startImmediately: Bool {
        true
    }
    
    func cleanup(after request: Request) {
    }
    func retryResult(for request: Request, dueTo error: AFError, completion: @escaping (RetryResult) -> Void) {
    }
    func retryRequest(_ request: Request, withDelay timeDelay: TimeInterval?) {
    }
}
