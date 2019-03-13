//
//  ArtistSongsListInteractor.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/06.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation

// this does all the busines logic of our APP
class ArtistSongsListInteractor : ArtistSongsListViewInteractorInputProtocol {
   
    var presenter: ArtistSongsListViewInteractorOutputProtocol?
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocol?
    
    func retriveSongsList(artistName: String) {
        //All logic goes here


        let encodedArtistName = artistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ??
                String(artistName.split(separator: " ").first!)

        remoteDataManager?.retrieveSongsList(artistName: encodedArtistName)



    }
}

extension ArtistSongsListInteractor : ArtistSongsListDataManagerOutputProtocol {

    func onArtistSongsListRetrieved(_ songs: [SongModel]) {
        presenter?.didRetrieveSongs(songs)
    }

    func onError() {
        presenter?.onError()
    }

}