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
    private var audioPlayer: AVPlayer?
    private var audioItem: AVPlayerItem?
    private var musicTimer: DispatchSourceTimer?
    
    @Published var songListData: [SongModel] = []
    @Published var state: HomeViewState = .noMusic
    
    var previousMusicId: Int = .zero
    var previousCell: HomeTableViewCell?
    var networkService: NetworkServiceProtocol = NetworkService()

    func fetchSongData(searchText: String) {
        view?.triggerLoadingView(startLoading: true)
        networkService.request(service: HomeService.getSongData(name: searchText), object: SongResponse.self) {[weak self] result in
            switch result {
            case .success(let response):
                let filteredResponse = response.results?.filter({$0.wrapperType == "track"})
                self?.songListData = filteredResponse ?? []
            case .failure(let error):
                self?.view?.showToast(message: "Error: Bad API")
            }
            self?.view?.triggerLoadingView(startLoading: false)
        }
    }
    
    func bindViewModel() {
        $songListData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let view = self?.view else {return}
                view.reloadTableView()
            }.store(in: &cancellables)
        
        $state
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                let previousIndex = self?.songListData.firstIndex(where: {$0.trackId == self?.previousMusicId}) ?? .zero
                self?.previousCell = self?.view?.tableView.cellForRow(at: IndexPath(row: previousIndex, section: .zero)) as? HomeTableViewCell
                switch self?.state {
                case .musicStop:
                    self?.view?.bottomPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    self?.audioPlayer?.pause()
                    self?.musicTimer?.cancel()
                    self?.musicTimer = nil
                    self?.previousCell?.state = .musicStop
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
                    self?.previousCell?.state = .musicPlaying
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
    
    func playSong(id: Int) {
        let index = songListData.firstIndex(where: {$0.trackId == id}) ?? .zero
        let previousIndex = songListData.firstIndex(where: {$0.trackId == previousMusicId}) ?? .zero
        previousCell = view?.tableView.cellForRow(at: IndexPath(row: previousIndex, section: .zero)) as? HomeTableViewCell
        previousCell?.stopUpdatingProgress()
        
        view?.musicTimeSlider.value = .zero
        
        if let data = songListData[index].previewUrl, let url = URL(string: data) {
            audioItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: audioItem)
            audioPlayer?.play()
        }
        
        state = .musicPlaying
        previousMusicId = id
    }
}
