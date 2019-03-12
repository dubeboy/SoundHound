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
}

protocol ArtistsListInteractorOutputProtocol {
    func didRetrieveArtists(artists: [ArtistModel])
    func onError()
}


protocol ArtistListRemoteDataManagerOutputProtocol {
    func didRetrieveArtists(artists: [ArtistModel])
    func onError()
}

protocol ArtistListRemoteDataManagerInputProtocol2 {
    var remoteRequestHandler: ArtistListRemoteDataManagerOutputProtocol? { get set }
    func retrieveArtists()

}

protocol ArtistListInteractorInputProtocol {
    var presenter: ArtistsListInteractorOutputProtocol? { get set }
    var remoteDataManager:  ArtistListRemoteDataManagerInputProtocol2? { get set }

    func retrieveArtists()

}

protocol ArtistListPresenterProtocol {
    // has reference to the intractor
    // need methods to wireframe to
    var view: ArtistListViewProtocol? { get set }
    var interactor: ArtistListInteractorInputProtocol? { get set }
    var wireFrame: ArtistListWireFrameProtocol? { get set }

    // wireframe

    func showArtistsSongs(artists: ArtistModel)
}

protocol  ArtistListViewProtocol: CommonNetworkProtocol {
    
    // reference to the intermediator
    var presenter: ArtistListPresenterProtocol? { get set }
    func showLoading()
    func showArtists(artists: [ArtistModel])

    
}
