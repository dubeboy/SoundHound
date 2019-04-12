//
// Created by Divine Dube on 2019-04-12.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation
import PKHUD
import FirebaseDatabase
extension SongsListViewController: SongsListViewProtocol {

    func onTopThreeArtistClicked() {
    }

    func showSongsList(songs: [SongModel]) {
        songList = songs
        tableViewSongs.reloadData()
        // we want to also load the top three images
        imgArtist1.dowloadFromServer(link: songList.first?.artworkURL ?? "")
        imgArtist2.dowloadFromServer(link: songList[1].artworkURL)
        imgArtist3.dowloadFromServer(link: songList[2].artworkURL)
        // we also want to set the names of the images here

        lblArtistName1.text = songList.first?.artistName
        lblArtistName2.text = songList[1].artistName
        lblArtistName3.text = songList[2].artistName
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

    // TODO this is very ambigious this will take the location and song ID
    func onSongIDReceived(song: SongModel) {
        let ref = Database.database().reference()
        NSLog(TAG, "the placename is \(placeNameString)")
        ref.child(placeNameString).setValue(["songID": song.id])
    }

}
