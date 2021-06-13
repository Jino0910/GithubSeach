//
//  GithubSearchTests.swift
//  GithubSearchTests
//
//  Created by rowkaxl on 2021/06/12.
//

import XCTest
@testable import GithubSearch

class GithubSearchTests: XCTestCase {
    
    var afSessionManager = AFSessionManagerStub()
    var viewController: ViewController!

    override func setUpWithError() throws {
        self.afSessionManager = AFSessionManagerStub()
        
        self.viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.viewController.viewModel =
            ViewModel(
                dependency: ViewModel.Dependency(
                    apiManager: APIManager(
                        sessionManager: afSessionManager
                    )
                )
            )
        self.viewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
//    func testSearchBar_whenSearchBarSearchButtonClicked_searchWithText() {
//      // when
//      let searchBar = self.viewController.searchController.searchBar
//      searchBar.text = "RxSwift"
//      searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
//
//      // then
//        let query = try? afSessionManager.requestParameters?.convertible.asURL().query
//        XCTAssertTrue(query?.contains("RxSwift") ?? false)
//    }

    func testTableView_matchRepositories() {
        // given
        
        let RepositoryModel = RepositoryModel(totalCount: 0,
                        incompleteResults: false,
                        items: [RepositoryModel.Item(id: 0, nodeID: "", name: "first", fullName: "", itemPrivate: true, owner: nil, htmlURL: nil, itemDescription: nil, fork: nil, url: nil, forksURL: nil, keysURL: nil, collaboratorsURL: nil, teamsURL: nil, hooksURL: nil, issueEventsURL: nil, eventsURL: nil, assigneesURL: nil, branchesURL: nil, tagsURL: nil, blobsURL: nil, gitTagsURL: nil, gitRefsURL: nil, treesURL: nil, statusesURL: nil, languagesURL: nil, stargazersURL: nil, contributorsURL: nil, subscribersURL: nil, subscriptionURL: nil, commitsURL: nil, gitCommitsURL: nil, commentsURL: nil, issueCommentURL: nil, contentsURL: nil, compareURL: nil, mergesURL: nil, archiveURL: nil, downloadsURL: nil, issuesURL: nil, pullsURL: nil, milestonesURL: nil, notificationsURL: nil, labelsURL: nil, releasesURL: nil, deploymentsURL: nil, createdAt: "", updatedAt: "2021", pushedAt: "", gitURL: nil, sshURL: nil, cloneURL: nil, svnURL: nil, homepage: nil, size: 0, stargazersCount: 100, watchersCount: 0, language: "Swift", hasIssues: nil, hasProjects: nil, hasDownloads: nil, hasWiki: nil, hasPages: nil, forksCount: nil, mirrorURL: nil, archived: nil, disabled: nil, openIssuesCount: nil, license: nil, forks: nil, openIssues: nil, watchers: nil, defaultBranch: nil, score: nil)])

        self.viewController.viewModel.repositories.accept(RepositoryModel)
        
        // then
        let numberOfRows = self.viewController.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 1)
        
        let cell = self.viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! RepositoryTableViewCell
        
        XCTAssertEqual(cell.nameLabel.text, "name: first")
        XCTAssertEqual(cell.stargazersCountLabel.text, "stargazersCount: 100")
        XCTAssertEqual(cell.updatedAtLabel.text, "updatedAt: 2021")
        XCTAssertEqual(cell.languageLabel.text, "language: Swift")
    }

}
