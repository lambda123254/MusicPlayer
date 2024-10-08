//
//  HomeService.swift
//  Services
//
//  Created by Reza Mac on 21/09/24.
//

import Alamofire

public enum HomeService: NetworkLayer {
    case getSongData(name: String)
}

public extension HomeService {
    var baseURL: String {
        return "https://itunes.apple.com/"
    }
    
    var path: String {
        switch self {
        case .getSongData:
            return "search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSongData:
            return .get
        }
    }
    
    var encoding: URLEncoding {
        switch self {
        case .getSongData:
            return .default
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .getSongData(let name):
            return ["term" : name]
        }
    }
}
