//
//  GithubAPI.swift
//  GithubSearch
//
//  Created by rowkaxl on 2021/06/12.
//

import Foundation
import Alamofire

enum GithubAPI {
    case repository(query: String, page: Int)
}

extension GithubAPI {
    
    // base url
    var baseURL: String {
        return "https://api.github.com"
    }
    
    // path
    var path: String {
        
        switch self {
        case let .repository(query, page):
            return "\(baseURL)/search/repositories?q=\(query)&page=\(page)"
        }
    }
    
    // method
    var method: HTTPMethod {
        switch self {
        case .repository:
            return .get
        }
    }
    
    // headers
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers["Accept"] = "application/vnd.github.v3+json"
        return headers
    }
    
    // paramaters
    var paramaters: [String: Any] {
        switch self {
        default: return [:]
        }
    }
}
