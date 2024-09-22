//
//  HomeTests.swift
//  HomeTests
//
//  Created by Reza Mac on 21/09/24.
//

import XCTest
import Services
import Common
@testable import Home

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<SongResponse, Error>?
    func request<T>(service: Services.NetworkLayer, object: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if let result = result as? Result<T, Error> {
            completion(result)
        }
    }
    
}

final class HomeTests: XCTestCase {
    var view: HomeView!
    var viewModel: HomeViewModel!
    var networkService: MockNetworkService = MockNetworkService()
    
    override func setUp() {
        super.setUp()
        view = HomeView()
        viewModel = HomeViewModel()
        viewModel.networkService = MockNetworkService()
        view.viewModel = viewModel
        viewModel.view = view
    }
    
    override func tearDown() {
        view = nil
        viewModel = nil
        super.tearDown()
    }
    
//    func testFetchSongDataSuccess() {
//        let song1 = SongModel(trackId: 1, wrapperType: "track", trackName: "Song 1", artistName: "Artist 1", collectionName: "Album 1", previewUrl: nil)
//        let song2 = SongModel(trackId: 2, wrapperType: "album", trackName: "Song 2", artistName: "Artist 2", collectionName: "Album 2", previewUrl: nil)
//        let mockResponse = SongResponse(resultCount: 30, results: [
//            song1,
//            song2
//        ])
//        networkService.result = .success(mockResponse)
//        
//        viewModel.fetchSongData(searchText: "Test")
//        
//        XCTAssertEqual(viewModel.songListData.count, 1)
//        XCTAssertEqual(viewModel.songListData.first?.trackName, "Song 1")
//    }
    
    func testFetchSongDataFailure() {
        networkService.result = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        viewModel.fetchSongData(searchText: "Test")
        XCTAssertTrue(viewModel.songListData.isEmpty)
    }
    
    func testInitialStateIsMusicFirstPlaying() {
        viewModel.state = .musicPlaying
        viewModel.playButtonTapped()
        XCTAssertEqual(viewModel.state, .musicStop)
    }
    
    func testInitialStateIsMusicIsPausedThenPlay() {
        viewModel.state = .musicStop
        viewModel.playButtonTapped()
        XCTAssertEqual(viewModel.state, .musicPlaying)
    }
    
//    func testPlayButtonTappedChangesStateToMusicPlaying() {
//        view.bottomPlayButtonTapped()
//        viewModel.playButtonTapped()
//        XCTAssertEqual(viewModel.state, .musicPlaying)
//    }
//    
//    func testPlayButtonTappedTwiceChangesStateBackToMusicStop() {
//        viewModel.playButtonTapped() // First tap to play music
//        viewModel.playButtonTapped() // Second tap to stop music
//        XCTAssertEqual(viewModel.state, .musicStop)
//    }
}
