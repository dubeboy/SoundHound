//
//  SongsListViewViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import PKHUD

class SongsListViewController: UIViewController {
    
    @IBOutlet weak var tableViewSongs: UITableView!
    var presenter: SongListPresenterProtocol?
    var songList: [SongModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableViewSongs.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
}

extension SongsListViewController: SongsListViewProtocol {
    var presenter: SongsListViewProtocol? {
        get {
            <#code#>
        }
        set {
            <#code#>
        }
    }
    
    
    func showSongsList(songs: [SongModel]) {
        songList = songs
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

extension SongsListViewController:  UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewSongs.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        let artistName: String = songList[indexPath.row].artistName
        let songName: String = songList[indexPath.row].name
        let genre: String = songList[indexPath.row].genre
        let albumName: String = songList[indexPath.row].albumName
        cell.lblArtistName.text = artistName
        cell.lblSongName.text = songName
        cell.lblGenre.text = genre
        cell.lblAlbumName.text = albumName
        //ASK: I dont get why this whould be forced to unwrapped
        let cellImageView = cell.imgAlbumCover!
        // will download image later
        let albumCoverURL = songList[indexPath.row].artworkURL
        cellImageView.dowloadFromServer(link: albumCoverURL)
        
        return cell
    }
}
