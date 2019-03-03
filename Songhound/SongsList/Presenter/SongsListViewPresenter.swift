//
//  SongsListViewPresenter.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

// so this classes charectoristic is defined by this protocol that it inherits from
//
class SongsListViewPresenter: SongListPresenterProtocol {
    weak var view: SongsListViewProtocol?
    var interactor: SongsListInteratorInputProtocol?
    var wireframe: SongsListViewWireFrameProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.retrieveSongsList()
    }
    
    func showSongDetail(forSong song: SongModel) {
        wireframe?.presentSongDetailsScreen(from: view!, forSong: song)
    }

}

extension SongsListViewPresenter: SongsListInteratorOutputProtocol {
    func didRetrieveSongs(_ songs: [SongModel]) {
        view?.hideLoading()
        view?.showSongsList(songs: songs)
    }
    
    func onError() {
        view?.hideLoading()
        view?.showError()
    }
}
