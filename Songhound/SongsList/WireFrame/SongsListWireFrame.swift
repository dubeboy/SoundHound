//
//  SongsListWireFrame.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/02.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class SongsListWireFrame: SongsListViewWireFrameProtocol {
    // some how this is static yoh
    class func createSongsListModule() -> UIViewController {
        // instatiate the main view controller
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "SongsViewNavigationController")

        if let view = navController.children.first as? SongsListViewController {
            // instatiate the presenter here bro
            var presenter: SongListPresenterProtocol &
                           SongsListInteratorOutputProtocol = SongsListViewPresenter()
            var interactor: SongsListInteratorInputProtocol &
                            SongsListRemoteDataManagerOutputProtocol = SongsListInterator()
            //  let localDataManager: SongsListDataManagerInputProtocol = No local data manager not as of yet bro
            let remoteDataManager: SongsListRemoteDataManagerInputProtocol = SongListRemoteDataManager()
            let wireframe: SongsListWireFrame = SongsListWireFrame()

            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDataManager = remoteDataManager
            remoteDataManager.remoteRequestHandler = interactor

            return navController
        }
        return UIViewController()
    }

    //actuall wireframing methods

    func presentSongDetailsScreen(from view: SongsListViewProtocol, forSong song: SongModel) {
        let songDetails = SongDetailsWireFrame.createSongDetailModule(forSong: song)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(songDetails, animated: true)
        }
    }

    func presentSongsListViewScreen(from view: SongsListViewProtocol, forArtist artist: ArtistModel) {
        let artistSongsList = ArtistsListViewWireFrame.createArtistListViewModule(forArtist: artist)

        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(artistSongsList, animated: true)
        }
    }

    func presentMoreArtists(from view: SongsListViewProtocol) {
        let artistList = ArtistListWireFrame.createArtistListModule()

        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(artistList, animated: true)
        }
    }
}
