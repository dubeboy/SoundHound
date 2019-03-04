//
//  SongsListInteractor.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation


// the buss logic goes here

class SongsListInterator: SongsListInteratorInputProtocol {
    var presenter: SongsListInteratorOutputProtocol?
    var localDataManager: SongsListLocalDataManagerInputProtocol?
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol?
    
    func retrieveSongsList() {
        
        remoteDataManager?.retrieveSongsList()

//        do {
            // try loading from local storage yohh!
//            if let songsList = try localDataManager?.retriveSongList() {
//                // Cool 😎
//                let songsModelList = songsList.map() { song in
//                    return SongModel(id: Int(song.id), title: song.title, imageURL: song.imageURL, artistName: song.artistName)
//                }
//                if songsModelList.isEmpty {
//                    remoteDataManager?.retrieveSongsList()
//                } else {
//                    presenter?.didRetrieveSongs(songsModelList)
//                }
//            } else {
//                remoteDataManager?.retrieveSongsList()
//            }
//        } catch {
//            presenter?.didRetrieveSongs([])
//        }
    }
}

extension SongsListInterator: SongsListRemoteDataManagerOutputProtocol {
    func onSongsRetrieved(_ songs: [SongModel]) {
        presenter?.didRetrieveSongs(songs)
        
        // should do local data later bro
        
//        for songModel in songs {
//            do {
//                // saves should happen on another thread
//                try localDataManager?.saveSong(id: songModel.id, name: songModel.name, artistName: songModel.artistName, imageURL: songModel.imageURL)
//            } catch {
//                print("oops could not save songs bro")
//            }
//        }
    }
    func onError() {
        presenter?.onError()
    }
}
