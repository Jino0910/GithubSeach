//
//  ViewModel.swift
//  GithubSearch
//
//  Created by rowkaxl on 2021/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {

    struct Dependency {
        let apiManager: APIManagerProtocol!
    }
    private let dependency: Dependency!
    private let bag = DisposeBag()
    
    // MARK: - Input
    let query = BehaviorRelay<String>(value: "")
    let page = BehaviorRelay<Int>(value: 1)

    // MARK: - Output
    let repositories = BehaviorRelay<RepositoryModel?>(value: nil)
    
    // MARK: - Init
    init(dependency: Dependency) {
        self.dependency = dependency
        bindOutput()
    }
    
    func bindOutput() {
        query
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .skip(1)
            .flatMapLatest{ [weak self] query -> Observable<RepositoryModel> in
                guard let self = self else { return .empty() }
                if query.isEmpty {
                    return .just(RepositoryModel(totalCount: 0, incompleteResults: false, items: []))
                } else {
                    self.page.accept(1)
                    return self.dependency
                        .apiManager
                        .request(target: .repository(query: query, page: self.page.value))
                        .map({ (model) -> RepositoryModel in
                            return model
                        })
                }
            }
            .bind(to: repositories)
            .disposed(by: bag)
        
        page
            .do(onNext: { value in
                print("value = \(value)")
            })
            .filter{ $0 != 1 }
            .filter({ [weak self]_ in
                guard let self = self else { return false }
                guard let repositories = self.repositories.value else { return false }
                return self.page.value * RepositoryModel.defaultPerPage < repositories.totalCount + RepositoryModel.defaultPerPage
            })
            .distinctUntilChanged()
            .flatMapLatest{ [weak self] page -> Observable<RepositoryModel> in
                guard let self = self else { return .empty() }
                guard var repositories = self.repositories.value else { return .empty() }
                return self.dependency
                    .apiManager
                    .request(target: .repository(query: self.query.value, page: page))
                    .map({ (model) -> RepositoryModel in
                        return model
                    })
                    .map { repositoryModel in
                        repositories.items.append(contentsOf: repositoryModel.items)
                        return repositories
                    }
            }
            .bind(to: repositories)
            .disposed(by: bag)
        
    }
}
