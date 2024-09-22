//
//  SongResponse.swift
//  Common
//
//  Created by Reza Mac on 21/09/24.
//

import Foundation

public struct SongResponse: Codable {
    public let resultCount: Int?
    public let results: [SongModel]?
    
    public init(resultCount: Int? = nil, results: [SongModel]? = nil) {
        self.resultCount = resultCount
        self.results = results
    }
}
