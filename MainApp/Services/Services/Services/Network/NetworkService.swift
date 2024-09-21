//
//  NetworkService.swift
//  Services
//
//  Created by Reza Mac on 21/09/24.
//

import Alamofire

public final class NetworkService {
    
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
                        print("Error decoding data \(error)")
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
