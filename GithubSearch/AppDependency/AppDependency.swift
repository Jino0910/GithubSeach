//
//  AppDependency.swift
//  GithubSearch
//
//  Created by rowkaxl on 2021/06/12.
//

import Foundation
import Alamofire

struct AppDependency {
    static let apiManager = APIManager(sessionManager: Session.default)
}
