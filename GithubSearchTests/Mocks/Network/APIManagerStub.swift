//
//  APIManagerStub.swift
//  GithubSearchTests
//
//  Created by rowkaxl on 2021/06/13.
//

@testable import GithubSearch
@testable import RxSwift

final class APIManagerStub: APIManagerProtocol {
    
    @discardableResult
    func request<D: Decodable>(target: GithubAPI) -> Observable<D> {
        return Observable<D>()
    }
}
