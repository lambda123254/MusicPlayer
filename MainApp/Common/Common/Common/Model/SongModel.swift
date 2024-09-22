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
    public let artworkUrl100: String?
    
    public init(trackId: Int?, wrapperType: String?, trackName: String?, artistName: String?, collectionName: String?, previewUrl: String?, artworkUrl100: String?) {
        self.trackId = trackId
        self.wrapperType = wrapperType
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = collectionName
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100
    }
}
