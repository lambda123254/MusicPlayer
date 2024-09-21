//
//  LSViewModel.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import Services
import Common

class HomeViewModel: ObservableObject {
    weak var view: HomeView?
    
    private var networkService: NetworkService = NetworkService()
    
    @Published var songListData: [SongModel] = []
    
    func fetchSongData() {
        networkService.request(service: HomeService.getSongData(name: ""), object: SongResponse.self) {[weak self] result in
            switch result {
            case .success(let response):
                self?.songListData = response.results ?? []
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
