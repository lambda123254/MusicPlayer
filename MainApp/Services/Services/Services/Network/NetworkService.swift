//
//  NetworkService.swift
//  Services
//
//  Created by Reza Mac on 21/09/24.
//

import Alamofire

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(service: NetworkLayer, object: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

public final class NetworkService: NetworkServiceProtocol {
    
    public init (){}
    
    public func request<T: Decodable>(service: NetworkLayer, object: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        if let url = URL(string: "\(service.baseURL)\(service.path)") {
            AF.request(url, method: service.method, parameters: service.parameter, encoding: service.encoding).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let res = try JSONDecoder().decode(T.self, from: data ?? Data())
                        completion(.success(res))
                    } catch let error {
                        print("Error decoding data \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
