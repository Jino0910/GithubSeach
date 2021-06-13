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

    var viewModel: ViewModel!
    private let bag = DisposeBag()
    
    public let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet private(set) var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension ViewController {
    
    private func configure() {
        configureUI()
        configureRx()
    }
    
    private func configureUI() {
//        self.searchController.delegate = self
        self.searchController.searchBar.autocapitalizationType = .none
        // 검색중 검색바 아래 페이지 dim 처리
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        
//        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "검색"
        self.searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        
        self.navigationController?.navigationBar.topItem?.title = "Github"

        self.navigationItem.searchController = searchController
        // 검색전 스크롤시 검색바 접혀 사라짐 여부
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        // 상위 클래스안에 포함될지 여부
        self.definesPresentationContext = true
    }
    
    private func configureRx() {
        
        // 검색바 입력
        self.searchController.searchBar
            .rx
            .text
            .map{ $0 ?? "" }
            .asObservable()
            .bind(to: viewModel.query)
            .disposed(by: bag)
        
        // 저장소 정보 바인딩
        self.viewModel.repositories
            .map{ $0?.items ?? [] }
            .bind(to: self.tableView.rx.items(cellIdentifier: "RepositoryTableViewCell")) { index, item, cell in
                if let cell = cell as? RepositoryTableViewCell {
                    cell.configure(item: item)
                }
            }
            .disposed(by: bag)
        
        // 페이징 처리
        self.tableView.rx
            .willEndDragging
            .filter { [weak self](_, targetContentOffset) in
                guard let self = self else { return false }
                let tableViewContentSizeHeight = self.tableView.contentSize.height
                let targetContentOffsetPointeeY = targetContentOffset.pointee.y + self.tableView.bounds.height + (self.tableView.bounds.height/2) // tableView 높이 반만큼 미리 call

                return Int(tableViewContentSizeHeight) <= Int(targetContentOffsetPointeeY)
            }
            .map{ [weak self]_ -> Int in
                (self?.viewModel.page.value ?? 0) + 1
            }
            .bind(to: viewModel.page)
            .disposed(by: bag)
    }
}
