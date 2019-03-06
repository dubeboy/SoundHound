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
    
    func retriveSongsList() {
        // no logic here yet
        // just calling the remote data manager to fetch the data
        
         remoteDataManager?.retriveSongsList()
        
    }
}
