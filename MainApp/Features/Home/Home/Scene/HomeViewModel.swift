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
    
    var previousMusicId: Int = .zero
    var previousCell: HomeTableViewCell?
    
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
                guard let view = self?.view else {return}
                view.reloadTableView()
                view.tableView.visibleCells.forEach({ cell in
                    let cell = cell as? HomeTableViewCell
                    if cell?.trackId == self?.previousMusicId {
                        cell?.updateProgress(maxProgress: 30, currentDuration: CGFloat(view.musicTimeSlider.value))
                    } else {
                        cell?.stopUpdatingProgress()
                    }
                })
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
