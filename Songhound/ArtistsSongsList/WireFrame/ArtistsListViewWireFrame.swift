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
            let presenter = 
        }
        return UIViewController
    }
    
    
    
}
