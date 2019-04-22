//
// Created by Divine Dube on 2019-03-13.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import UIKit

class ArtistListWireFrame: ArtistListWireFrameProtocol {

    typealias PresenterInputInteratorOutput = (ArtistListPresenterProtocol &
                                               ArtistsListInteractorOutputProtocol)

    typealias InteractorInputRemoteDataManagerOutput = (ArtistListInteractorInputProtocol &
                                                        ArtistListRemoteDataManagerOutputProtocol)

    class func createArtistListModule() -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ArtistListViewController")
        if let view = viewController as? ArtistListViewController {
            var presenter: PresenterInputInteratorOutput = ArtistListPresenter()
            let wireframe: ArtistListWireFrame = ArtistListWireFrame()
            var interactor: InteractorInputRemoteDataManagerOutput = ArtistListInteractor()
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
    func presentSongDetailView(from view: ArtistListViewProtocol, forSong song: SearchModelValue) {
        let artistSongsList = SongDetailsWireFrame.createSongDetailModule(forSong: SongModel(id: song.id!,
                name: song.name,
                artistName: "",
                albumName: "",
                genre: "",
                popularity: 0,
                artworkURL: "",
                artist: ArtistModel(name: "", artistID: 0)))
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(artistSongsList, animated: true)
        }
    }
}
