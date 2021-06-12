//
//  ViewController.swift
//  GithubSearch
//
//  Created by rowkaxl on 2021/06/12.
//

import UIKit
import Alamofire
import RxSwift

class ViewController: UIViewController {
    
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let apiManager = APIManager(sessionManager: Session.default)
        
        
//        apiManager.request(target: .repository("swift"))
//            .flatMap({ (model) -> Observable<RepositoryModel> in
//                return .just(model)
//            })
//            .subscribe(onNext: { (model) in
//                print(model)
//            })
//            .disposed(by: bag)
        
//        apiManager
//            .request(target: .repository("Jino0910"))
//            .map{ RepositoryModel(model: $0)}
//            .subscribe(onNext: { (_) in
//                print("1")
//            })
//            .disposed(by: bag)
            
    }


}

