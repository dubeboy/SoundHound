//
//  SongsListInteractor.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation

class SongsListInterator: SongsListInteratorInputProtocol {
    var presenter: SongsListInteratorOutputProtocol?
    var localDataManager: SongsListLocalDataManagerInputProtocol?
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol?
    
    func retrieveSongsList() {
        do {
            // try loading from local storage yohh!
            if let songsList = try localDataManager?.retriveSongList() {
                // Cool 😎
                let songsModelList = songsList.map() {song in
                    return SongModel(id: Int(song.id), title: song.title, imageURL: song.imageURL, artistName: song.artistName)
                }
                if songsModelList.isEmpty {
                    remoteDataManager?.retrieveSongsList()
                } else {
                    presenter?.didRetrieveSongs(songsModelList)
                }
            } else {
                remoteDataManager?.retrieveSongsList()
            }
        } catch {
            presenter?.didRetrieveSongs([])
        }
    }
}

extension SongsListInterator: SongsListRemoteDataManagerOutputProtocol {
    func onSongsRetrieved(_ songs: [SongModel]) {
        presenter?.didRetrieveSongs(songs)
        
        for songModel in songs {
            
            do {
                // saves should happen on another thread
                try localDataManager?.saveSong(id: songModel.id, title: songModel.title, artistName: songModel.artistName, imageURL: songModel.imageURL)
            } catch {
                
            }
        }
    }
    
    func onError() {
        presenter?.onError()
    }
}
