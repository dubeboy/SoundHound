//
//  File.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/12.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

protocol ArtistListWireFrameProtocol {

    static func createArtistListModule() -> UIViewController

    // this is where we do the rourtng
    func presentSongDetailView(from view: ArtistListViewProtocol, forSong song: SearchModelValue)
}

protocol ArtistsListInteractorOutputProtocol {
    func didRetrieveArtists(searchResults: SearchModel)
    func onError()
}

protocol ArtistListRemoteDataManagerOutputProtocol {
    func didRetrieveArtists(searchResults: SearchModel)
    func onError()
}

protocol ArtistListRemoteDataManagerInputProtocolTwo {
   var remoteRequestHandler: ArtistListRemoteDataManagerOutputProtocol? { get set }
    func retrieveArtists()
    func searchForSongName(songName: String, location: String)
}

protocol ArtistListRemoteDataManagerInputProtocolThree: ArtistListRemoteDataManagerInputProtocolTwo {

}

protocol ArtistListInteractorInputProtocol {
    var presenter: ArtistsListInteractorOutputProtocol? { get set }
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocolTwo? { get set }

    func retrieveArtists()
    func searchForArtist(songName: String, location: String)
}

protocol ArtistListPresenterProtocol {
    // has reference to the intractor
    // need methods to wireframe to
    var view: ArtistListViewProtocol? { get set }
    var interactor: ArtistListInteractorInputProtocol? { get set }
    var wireFrame: ArtistListWireFrameProtocol? { get set }

    // wireframe
    func presentSongDetails(song: SearchModelValue)
    func viewDidLoad()
        func searchForSongs(songName: String, location: String)
}

protocol ArtistListViewProtocol: CommonNetworkProtocol {
    // reference to the intermediator
    var presenter: ArtistListPresenterProtocol? { get set }
    func showLoading()
    func showArtists(searchResults: SearchModel)
}
