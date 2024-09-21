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

enum HomeViewState {
    case musicPlaying
    case musicStop
    case noMusic
}

class HomeViewModel {
    weak var view: HomeView?
    
    private var networkService: NetworkService = NetworkService()
    private var state: HomeViewState = .noMusic
    private var audioPlayer: AVPlayer?
    private var musicTimer: Timer?

    @Published var songListData: [SongModel] = []
    
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
    
    func bottomPlayButtonTapped() {
        switch state {
        case .musicPlaying:
            view?.bottomPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            state = .musicStop
            audioPlayer?.pause()
            musicTimer?.invalidate()
            musicTimer = nil
        case .musicStop:
            view?.bottomPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            state = .musicPlaying
            audioPlayer?.play()
            musicTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] _ in
                self?.view?.musicTimeSlider.value += 1
            })
        case .noMusic:
            break
        }

    }
    
    func playSong(index: Int) {
        musicTimer?.invalidate()
        view?.musicTimeSlider.value = .zero
        view?.bottomPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        if let data = songListData[index].previewUrl, let url = URL(string: data) {
            audioPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
            audioPlayer?.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.view?.musicTimeSlider.maximumValue = Float(CMTimeGetSeconds(self?.audioPlayer?.currentItem?.duration ?? CMTime()))
        }
        
        state = .musicPlaying
        musicTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] _ in
            self?.view?.musicTimeSlider.value += 1
        })
    }
}
