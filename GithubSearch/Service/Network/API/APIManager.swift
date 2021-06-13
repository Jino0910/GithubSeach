//
//  APIManager.swift
//  GithubSearch
//
//  Created by rowkaxl on 2021/06/12.
//

import Foundation
import RxSwift
import Alamofire

protocol APIManagerProtocol {
    @discardableResult
    func request<D: Decodable>(target: GithubAPI) -> Observable<D>
}

final class APIManager: APIManagerProtocol {
    
    private let sessionManager: AFSessionManagerProtocol
    
    init(sessionManager: AFSessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    @discardableResult
    func request<D: Decodable>(target: GithubAPI) -> Observable<D> {
        return Observable<D>.create { observer in
//            print("============================================")
            print("API REQUEST")
            print(target.path)
//            print("============================================")
            
            self.sessionManager.request(target.path,
                                        method: target.method,
                                        parameters: target.paramaters,
                                        encoding: URLEncoding.default,
                                        headers: nil,
                                        interceptor: nil,
                                        requestModifier: nil)
                .validate()
                .responseDecodable(of: D.self) { response in
                    
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                    case .failure(let error):
                        observer.onError(error)
                    }
                    
                    observer.onCompleted()
                }
            
            return Disposables.create {}
        }
    }
}
