//
//  NetworkLayer.swift
//  Services
//
//  Created by Reza Mac on 21/09/24.
//

import Alamofire

public protocol NetworkLayer {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: URLEncoding { get }
    var parameter: Parameters { get }
}
