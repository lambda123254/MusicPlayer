//
//  HomeView.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit
import Combine

class HomeView: UIViewController {
    
    var viewModel: HomeViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    private func bindViewModel() {
        viewModel?.$songListData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
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
}
