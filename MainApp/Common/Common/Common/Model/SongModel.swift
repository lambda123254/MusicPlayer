//
//  SongModel.swift
//  Common
//
//  Created by Reza Mac on 21/09/24.
//

import Foundation

public struct SongModel: Codable {
    public let trackId: Int?
    public let wrapperType: String?
    public let trackName: String?
    public let artistName: String?
    public let collectionName: String?
    public let previewUrl: String?
}
