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
        
        for (i , song ) in songList.enumerated() {
            // gangstar stuff here bro
            switch i {
            case 0:
                  imgArtist1.dowloadFromServer(link: songList.first?.artworkURL ?? "")
                  lblArtistName1.text = song.artistName
            case 1:
                 imgArtist2.dowloadFromServer(link: song.artworkURL)
                 lblArtistName2.text = song.artistName
            case 2:
                 imgArtist3.dowloadFromServer(link: song.artworkURL)
                 lblArtistName3.text = song.artistName
            case 3:
                break
            default:
                break
            }
        }
    }

    func showError() {
        HUD.flash(.label("Oops an error occurred!"), delay: 2.0)
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
        print("SLVP: the placename  is;\(placeNameString)")
        ref.child(placeNameString).child("\(song.id)").setValue(["songID": song.id, "name": song.name])
    }

}
