//
//  ArtistListViewProtocol.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/04.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import UIKit

// TODO should probably extract the common methods of these protocols
// did this for ease of customization
protocol ArtistsListViewProtocol: CommonNetworkProtocol {

    var presenter: ArtistSongsListViewPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showSongs(with songs: [SongModel])
    func showLoading(forArtist artist: ArtistModel)
}

// TODO a bit of inconsitencey this module is called the ArtistsList
protocol ArtistsListViewWireFrameProtocol {
    // bootstrapper
    static func createArtistListViewModule(forArtist artist: ArtistModel)  -> UIViewController
    
    // any routing that I need should be stated here!
    func presentSongDetailsScreen(from view: ArtistsListViewProtocol, forSong song: SongModel)
}

protocol ArtistSongsListViewPresenterProtocol {
    // so that once everything is called and done this will cleaned by ARC
    var view: ArtistsListViewProtocol? { get set }
    // the presenter has an input from which it gets the data
    // i.e the interactor. this interactor has an output in which it has a reference to this presenter
    var interactor: ArtistSongsListViewInteractorInputProtocol? { get set }
    var wireFrame: ArtistsListViewWireFrameProtocol? { get set }
    var artist: ArtistModel? { get set }
    
    //VIEW -> PRESENT
    func viewDidLoad()

    func showSongDetail(forSong song: SongModel)


}


// this describes how we get the data from the interactor
protocol ArtistSongsListViewInteractorInputProtocol: class {
    var presenter: ArtistSongsListViewInteractorOutputProtocol? { get set }
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocol? { get set }
    
    // From PRESENTER -> INTERACTOR asking for input
    // will callback presenter when its done
    func retriveSongsList(artistName: String)
}

// this protocol defines what happens to the data that goes out of the interactor
// define how the data goes out of the interactor
protocol ArtistSongsListViewInteractorOutputProtocol  {
    // from the interactor -> Presenter
    // this is how the interactor responds to the presenter
    func didRetrieveSongs(_ songs: [SongModel])
    func onError()
}

protocol ArtistListRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: ArtistSongsListDataManagerOutputProtocol? { get set }
    // RemoteData manager -> Interactor
    func retriveSongsList(artistName: String)
}

protocol ArtistSongsListDataManagerOutputProtocol {
    func onArtistSongsListRetrieved(_ songs: [SongModel])
    func onError()
}

