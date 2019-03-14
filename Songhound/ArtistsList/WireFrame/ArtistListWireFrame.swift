//
// Created by Divine Dube on 2019-03-13.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import UIKit

class ArtistListWireFrame: ArtistListWireFrameProtocol {
    class func createArtistListModule() -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ArtistListViewController")
        if let view = viewController as? ArtistListViewController {
            var presenter: (ArtistListPresenterProtocol & ArtistsListInteractorOutputProtocol) = ArtistListPresenter()
            let wireframe: ArtistListWireFrame = ArtistListWireFrame()
            var interactor: (ArtistListInteractorInputProtocol & ArtistListRemoteDataManagerOutputProtocol) = ArtistListInteractor()
            var remoteDataManager: ArtistListRemoteDataManagerInputProtocol2 = ArtistListRemoteDataManager()

            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDataManager = remoteDataManager
            remoteDataManager.remoteRequestHandler = interactor


            return view
        }
        return UIViewController()
    }

    // will have a func that actually routes to the artist page for song by that artist
    func presentArtistSongView(from view: ArtistListViewProtocol, forArtist artist: ArtistModel) {
        let artistSongsList = ArtistsListViewWireFrame.createArtistListViewModule(forArtist: artist)

        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(artistSongsList, animated: true)
        }
    }
}
