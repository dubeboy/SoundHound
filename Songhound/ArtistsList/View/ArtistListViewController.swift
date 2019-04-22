//
//  ArtistListViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019-03-12.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import PKHUD

class ArtistListViewController: UIViewController {

    var searchResults: [SearchModelValue] = []
    var presenter: ArtistListPresenterProtocol?
    @IBOutlet weak var artistTableView: UITableView!
    @IBOutlet weak var artistsSearchbar: UISearchBar!
    var locationString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        artistTableView.delegate = self
        artistTableView.dataSource = self
        artistsSearchbar.delegate = self
        locationString = UserDefaults.standard.string(forKey: "location")!
    }
}

extension ArtistListViewController: ArtistListViewProtocol {
    func showArtists(searchResults: SearchModel) {
        self.searchResults = searchResults.map({ (key, modelValue) in
            return modelValue
        })
        artistTableView.reloadData()
    }

    func showError() {
        HUD.flash(.label("Internet not connect"), delay: 2.0)
    }

    func showLoading() {
        HUD.show(.progress)
    }

    func hideLoading() {
        HUD.hide()
    }

}

// UITable extenstion
extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self
                .artistTableView
                .dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath)

        if let cell = cell as? ArtistTableViewCell {
            cell.lblArtistName.text = searchResults[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.presentSongDetails(song: searchResults[indexPath.row])
    }
}

extension ArtistListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchForSongs(songName: searchText, location:  locationString)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.artistsSearchbar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter?.searchForSongs(songName: "", location: "")
        //populateArtists()
    }
}
