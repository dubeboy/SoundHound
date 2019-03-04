//
//  SongsListViewProtocol.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

// ----
// defines what our presenter should be able to do
// ----

import UIKit

// these are the functions that are doable by our view when it interacts with the presenter
protocol SongsListViewProtocol: class {
    // maybe should be lazy ?
    var presenter: SongListPresenterProtocol? { get set }
    //presenter -> view
    func showSongsList(songs: [SongModel])

    //onTopThreeTopArtistsClicked

    func onTopThreeArtistClicked()

    // must be able to show a friendly error when it ocours so that we dont make our users cry
    func showError()
    // show that we loading some data
    func showLoading()
    // we want to be able to hide the loading progress bar
    func hideLoading()
}

//Song List presenter protocol
protocol SongListPresenterProtocol {
    var view: SongsListViewProtocol? { get set }
    var interactor: SongsListInteratorInputProtocol? { get set }
    var wireframe: SongsListViewWireFrameProtocol? { get set }
    
    // VIEW -> Presenter
    func viewDidLoad()
    func showSongDetail(forSong song: SongModel)
    func showSongs(forArtist artist: ArtistModel)
}

// we need the wireframe protocal so that this presenter can route to it desired page
protocol SongsListViewWireFrameProtocol: class {
    // TODO what does this do
    static func createSongsListModule() -> UIViewController
    // this function will actually route to the next screen
    // also give it the required data
    func presentSongDetailsScreen(from view: SongsListViewProtocol, forSong song: SongModel)
    func presentSongsListViewScreen(from view: SongsListViewProtocol, forArtist artist: ArtistModel)
    
}




protocol SongsListInteratorOutputProtocol: class {
    func didRetrieveSongs(_ songs: [SongModel])
    func onError()
}

protocol SongsListInteratorInputProtocol {
    var presenter: SongsListInteratorOutputProtocol? { get set }
    var localDataManager: SongsListLocalDataManagerInputProtocol? { get set }
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol? { get set }
    
    // PRESENTER - INTERACTOR
    func retrieveSongsList()
}

protocol SongsListDataManagerInputProtocol {
    //INTERATOR -> DATAMANAGER
    
}
protocol SongsListRemoteDataManagerInputProtocol: class {
    var remoteRequestHandler: SongsListRemoteDataManagerOutputProtocol? { get set }
    //REMOTEDATA MANAGER -> INTETRACTOR
    func retrieveSongsList()
}

protocol SongsListRemoteDataManagerOutputProtocol: class {
    //REMOTEDATAMODEEL -> INTERACTOR
    func onSongsRetrieved(_ songs: [SongModel])
    func onError()
}

protocol SongsListLocalDataManagerInputProtocol {
    // INTERACTOR -> LOCALDATAMANAGER
    func retriveSongList() throws -> [Song]
    func saveSong(id: Int, title: String, artistName: String, imageURL: String)
}


