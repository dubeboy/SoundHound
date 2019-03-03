//
//  SongsListViewViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import PKHUD

// TODO must be ablke to mod the navigation controller

class SongsListViewController: UIViewController {
    
    //top Items for the songs list view controller
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var imgArtist3: UIImageView!
    @IBOutlet weak var imgArtist2: UIImageView!
    @IBOutlet weak var imgArtist1: UIImageView!
    @IBOutlet weak var lblArtistName3: UILabel!
    @IBOutlet weak var lblArtistName2: UILabel!
    @IBOutlet weak var lblArtistName1: UILabel!
    @IBOutlet weak var lblPlaying: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    
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

//Song list view protocol
extension SongsListViewController: SongsListViewProtocol {
    func showSongsList(songs: [SongModel]) {
        songList = songs
        tableViewSongs.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do stuff when a cell is selected
    }
}
