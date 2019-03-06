//
//  ArtistsListViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/04.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import PKHUD

class ArtistsListViewController: UIViewController {

    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var artistName: UILabel!
    
    var songList: [SongModel] = []
    
    var presenter: ArtistSongsListViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // songsTableView.footerView = UIView()

        // Do any additional setup after loading the view.
    }
}

extension ArtistsListViewController: ArtistsListViewProtocol {

    func showSongs(with songs: [SongModel]) {
        songList = songs
        self.songsTableView.reloadData()
    }
    
    func showLoading(forArtist artist: ArtistModel) {
        HUD.show(.progress)
        self.artistName.text = artist.name
    }
    
    // they should be refactored to another page
    func showError() {
        HUD.flash(.label("Internet not connect"), delay: 2.0)
    }
    
    func hideLoading() {
        HUD.hide()
    }
}

extension ArtistsListViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.songsTableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        let song = songList[indexPath.row]
        cell.set(forSong: song)
        return cell
    }
}
