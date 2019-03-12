//
//  ArtistListViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019-03-12.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import PKHUD

class ArtistListViewController: ViewController {

    var presenter: ArtistListPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ArtistListViewController: ArtistListViewProtocol {
    func showArtists(artists: [ArtistModel]) {
        
    }

    func showError() {
        HUD.flash(.label("Internet not connect"), delay: 2.0)
    }

    func showLoading() {
        HUD.show(.progress)
    }

    func hideLoading() {
        HUD.hide()
    }
}


