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
// did this so that we can build our own methods for the ArtistList if need be
protocol ArtistsListViewProtocol: CommonNetworkProtocol {
    
}

// TODO a bit of inconsitencey this module is called the ArtistsList
protocol ArtistsListViewWireFrameProtocol {
    // bootstrapper
    static func createArtistListViewModule(forArtist artist: ArtistModel)  -> UIViewController
    
    // any routing that I need should be stated here!
}

protocol ArtistSongsListViewPresenterProtocol {
    // so that once everything is called and done this will cleaned by ARC
    var view: ArtistsListViewProtocol? { get set }
    // the presenter has an input from which it gets the data
    // i.e the interactor. this interactor has an output in which it has a reference to this presenter
    var interactor: ArtistSongsListViewInteractorInputProtocol? { get set }
    var wireFrame: ArtistsListViewWireFrameProtocol? { get set }
    
    //VIEW -> PRESENT
    func viewDidLoa()
    func showSongsList(forArtist artist: ArtistModel)
}


// this describes how we get the data from the interactor
protocol ArtistSongsListViewInteractorInputProtocol: class {
    var presenter: ArtistSongsListViewInteractorOutputProtocol? { get set }
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocol? { get set }
}

// this protocol defines what happens to the data that goes out of the interactor
// define how the data goes out of the interactor
protocol ArtistSongsListViewInteractorOutputProtocol  {
    // Interactor -> Presenter
    func didRetrieveSongs(_ songs: [SongModel])
    func onError()
}

protocol ArtistListRemoteDataManagerInputProtocol {
    // RemoteData manager -> Interactor
    func onArtistSongsRetrieved(_ posts: [SongModel])
    func onError()
}
