//
//  HomeView.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit
import AVFoundation

class HomeView: UIViewController {
    
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomPlayContainer: UIView!
    @IBOutlet weak var bottomPlayButton: UIButton!
    @IBOutlet weak var musicTimeSlider: UISlider!
    
    var loadingView: LoadingView = LoadingView()
    var toastView: ToastView?
    
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
        setupBottomMusicPlayer()
        setupLoadingView()
        viewModel?.bindViewModel()
    }
    
    func showToast(message: String) {
        toastView?.removeFromSuperview()
        toastView = ToastView(message: message)
        toastView?.show(in: self.view, duration: 3.0)
    }
    
    func setupLoadingView() {
        loadingView.frame = view.bounds
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        // Setup constraints to fit the entire screen
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    func setupBottomMusicPlayer() {
        musicTimeSlider.value = 0
        musicTimeSlider.minimumValue = 0
        musicTimeSlider.maximumValue = 30
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func triggerLoadingView(startLoading: Bool) {
        if startLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
    
    @objc func bottomPlayButtonTapped() {
        viewModel?.playButtonTapped()
    }
    
}

extension HomeView: UISearchBarDelegate {
    
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
            cell.trackId = data[indexPath.row].trackId
            
            if cell.trackId == viewModel?.previousMusicId {
                cell.updateProgress(maxProgress: 30, currentDuration: CGFloat(musicTimeSlider.value))
            } else {
                cell.stopUpdatingProgress()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? HomeTableViewCell
        bottomPlayContainer.isHidden = false
        viewModel?.playSong(id: cell?.trackId ?? .zero)
        cell?.updateProgress(maxProgress: 30)
    }
}
