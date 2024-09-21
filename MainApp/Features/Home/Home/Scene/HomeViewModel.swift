//
//  LSViewModel.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import Services
import Common
import UIKit
import AVFoundation
import Combine

enum HomeViewState {
    case musicPlaying
    case musicStop
    case noMusic
}

class HomeViewModel: NSObject {
    weak var view: HomeView?
    
    private var cancellables = Set<AnyCancellable>()
    private var networkService: NetworkService = NetworkService()
    private var audioPlayer: AVPlayer?
    private var audioItem: AVPlayerItem?
    private var musicTimer: DispatchSourceTimer?
    
    @Published var songListData: [SongModel] = []
    @Published var state: HomeViewState = .noMusic
    
    public override init() {
    }
    
    func fetchSongData(searchText: String) {
        networkService.request(service: HomeService.getSongData(name: searchText), object: SongResponse.self) {[weak self] result in
            switch result {
            case .success(let response):
                let filteredResponse = response.results?.filter({$0.wrapperType == "track"})
                self?.songListData = filteredResponse ?? []
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func bindViewModel() {
        $songListData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.view?.reloadTableView()
            }.store(in: &cancellables)
        
        $state
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                switch self?.state {
                case .musicStop:
                    self?.view?.bottomPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    self?.audioPlayer?.pause()
                    self?.musicTimer?.cancel()
                    self?.musicTimer = nil
                case .musicPlaying:
                    self?.musicTimer = DispatchSource.makeTimerSource()
                    self?.musicTimer?.schedule(deadline: .now() + 1, repeating: 1.0)
                    self?.view?.bottomPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                    self?.audioPlayer?.play()
                    self?.musicTimer?.setEventHandler {[weak self] in
                        DispatchQueue.main.async {
                            self?.view?.musicTimeSlider.value += 1
                        }
                    }
                    self?.musicTimer?.resume()
                default:
                    break
                }
            }.store(in: &cancellables)
    }
    
    func playButtonTapped() {
        if state == .musicPlaying {
            state = .musicStop
        } else if state == .musicStop {
            state = .musicPlaying
        }
    }
    
    func playSong(index: Int) {
        view?.musicTimeSlider.value = .zero
        if let data = songListData[index].previewUrl, let url = URL(string: data) {
            audioItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: audioItem)
            audioPlayer?.play()
        }

        state = .musicPlaying
    }
    
//    @objc func playerItemDidBecomeReady(notification: Notification) {
//        guard let playerItem = notification.object as? AVPlayerItem else { return }
//        if playerItem.status == .readyToPlay {
//            // Get the duration in seconds
//            let durationInSeconds = CMTimeGetSeconds(playerItem.duration)
//            print("Audio duration: \(durationInSeconds) seconds")
//            
//            // Convert to minutes if needed
//            let durationInMinutes = durationInSeconds / 60
//            print("Audio duration: \(durationInMinutes) minutes")
//        } else {
//            print("Player item is not ready to play.")
//        }
//    }
}
