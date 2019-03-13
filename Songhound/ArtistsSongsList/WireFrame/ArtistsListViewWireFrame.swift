//
//  ArtistsSongsListViewWireFrame.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/04.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import UIKit

class ArtistsListViewWireFrame: ArtistsListViewWireFrameProtocol {
    class func createArtistListViewModule(forArtist artist: ArtistModel) -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ArtistSongsListViewController")
        
        if let view = viewController as? ArtistsListViewController {
            var presenter: (ArtistSongsListViewPresenterProtocol & ArtistSongsListViewInteractorOutputProtocol) = ArtistSongListViewPresenter()
            let wireframe: ArtistsListViewWireFrameProtocol = ArtistsListViewWireFrame()
            let interactor: (ArtistSongsListViewInteractorInputProtocol & ArtistSongsListDataManagerOutputProtocol) = ArtistSongsListInteractor()
            var remoteDataManager: ArtistListRemoteDataManagerInputProtocol = ArtistsSongsListRemoteDataManager()


            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDataManager = remoteDataManager
            remoteDataManager.remoteRequestHandler = interactor

            presenter.artist = artist
            return viewController
            
        }
        return UIViewController()
    }


    func presentSongDetailsScreen(from view: ArtistsListViewProtocol, forSong song: SongModel) {
        let songDetails = SongDetailsWireFrame.createSongDetailModule(forSong: song)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(songDetails, animated: true)
        }
    }
    
    
    
}
