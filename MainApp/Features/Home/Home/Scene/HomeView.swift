//
//  HomeView.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit
import Combine
import AVFoundation

enum HomeViewState {
    case musicPlaying
    case musicStop
    case noMusic
}

class HomeView: UIViewController {
    
    var viewModel: HomeViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    private var state: HomeViewState = .noMusic
    private var audioPlayer: AVPlayer?
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomPlayContainer: UIView!
    @IBOutlet weak var bottomPlayButton: UIButton!
    
    
    init() {
        super.init(nibName: String(describing: HomeView.self), bundle: Bundle(for: HomeView.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchField()
        setupBottomPlayButton()
        bindViewModel()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.nib, forCellReuseIdentifier: HomeTableViewCell.string)
    }
    
    func setupSearchField() {
        searchField.delegate = self
    }
    
    func setupBottomPlayButton() {
        bottomPlayButton.addTarget(self, action: #selector(bottomPlayButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel?.$songListData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    @objc func bottomPlayButtonTapped() {
        switch state {
        case .musicPlaying:
            bottomPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            state = .musicStop
            audioPlayer?.pause()
        case .musicStop:
            bottomPlayButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            state = .musicPlaying
            audioPlayer?.play()
        case .noMusic:
            break
        }
    }
    
}

extension HomeView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchField.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchField.resignFirstResponder()
        viewModel?.fetchSongData(searchText: searchBar.text ?? "")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchField.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchField.resignFirstResponder()
        searchField.showsCancelButton = false
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.songListData.count ?? .zero
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.string, for: indexPath) as? HomeTableViewCell, let data = viewModel?.songListData {
            cell.songLabel.text = data[indexPath.row].trackName
            cell.artistLabel.text = data[indexPath.row].artistName
            cell.albumLabel.text = data[indexPath.row].collectionName
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bottomPlayContainer.isHidden = false
        state = .musicPlaying
        if let data = viewModel?.songListData[indexPath.row].previewUrl, let url = URL(string: data) {
            audioPlayer = AVPlayer(url: url)
            audioPlayer?.play()
        }
    }
}
