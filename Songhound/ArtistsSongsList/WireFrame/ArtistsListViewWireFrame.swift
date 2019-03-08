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
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ArtistListViewController")
        
        if let view = viewController as? ArtistsListViewController {
            var presenter: ArtistSongsListViewPresenterProtocol = ArtistSongListViewPresenter()
            let wireframe: ArtistsListViewWireFrameProtocol = ArtistsListViewWireFrame()
            
            view.presenter = presenter
            presenter.view = view
            presenter.artist = artist
            presenter.wireFrame = wireframe
            
            return viewController
            
        }
        return UIViewController()
    }
    
    
    
}
