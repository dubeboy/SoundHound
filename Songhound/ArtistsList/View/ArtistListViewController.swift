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

    var artists: [ArtistModel] = []
    var originalArtistListFromServer: [ArtistModel] = [] // sure could be done better yoh
    var presenter: ArtistListPresenterProtocol?
    @IBOutlet weak var artistTableView: UITableView!
    @IBOutlet weak var artistsSearchbar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        artistTableView.delegate = self
        artistTableView.dataSource = self
        artistsSearchbar.delegate = self

    }
}

extension ArtistListViewController: ArtistListViewProtocol {
    func showArtists(artists: [ArtistModel]) {
        self.artists = artists
        artistTableView.reloadData()
        originalArtistListFromServer = artists // can also be done on a background thread bro!
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
        return artists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.artistTableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell

        cell.lblArtistName.text = artists[indexPath.row].name
       // cell.imgArtist.dowloadFromServer(link: )
        //cell.lblNumHits.text = "\(artists[indexPath.row].numHits) hot songs"
        //  let str = artists[indexPath.row].isHot ? "🔥" :  "";
        //  cell.lblEmoji.text = str

//        cell.imgArtist. = // set the artist image

        return cell
    }
}

extension ArtistListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // bad code!!!
        if !searchText.isEmpty {
            artists = artists.filter { (artist: ArtistModel) -> Bool in
                return artist.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        } else {
            artists = originalArtistListFromServer
        }

        artistTableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.artistsSearchbar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        //populateArtists()
    }
}



