//
// Created by Divine Dube on 2019-03-11.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SongDetailPresenter: SongDetailPresenterProtocol {
    var view: SongDetailsViewProtocol?
    var wireframe: SongDetailWireFrameProtocol?
    var song: SongModel?
    var ref: DatabaseReference!

    func viewDidLoad() {
        // we should be showing a loading indicator
        view?.showLoading()
        if (song!.artistName.isEmpty) { // empty when coming from a search view
            // so we need to fetch from the firebase database
            ref = Database.database().reference()
            ref.child("\(song!.id)").observeSingleEvent(of: DataEventType.value) { snap, error in
                guard error == nil else {
                    return
                }

                let song = snap.value as! [String: AnyObject]
                let songModel = SongModel(id: song["songID"] as! UInt,
                        name: song["name"] as! String,
                        artistName: song["artistName"] as! String,
                        albumName: song["AlbumName"] as! String,
                        genre: song["genre"] as! String,
                        popularity: song["popularity"] as! Int,
                        artworkURL: song["artworkURL"] as! String,
                        artist: ArtistModel(name: song["artistName"] as! String, artistID: 0))
               self.showSongsOnView(song: songModel)
            }
        } else {
            showSongsOnView(song: song!)
        }
    }

    private func showSongsOnView(song: SongModel) {
        self.view?.hideLoading()
        self.view?.showSongsDetail(forSong: song)
    }
}
