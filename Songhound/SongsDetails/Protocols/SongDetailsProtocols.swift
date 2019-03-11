//
//  SongDetailsProtocols.swift
//  Songhound
//
//  Created by Divine Dube on 2019-03-11.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

// this will be implemented by the VIEW CONTROLLER
protocol SongDetailsViewProtocol {
    var presenter: SongDetailPresenterProtocol? {get set}

    func showSongsDetail(forSong song: SongModel)
}

// this will be inherited by the presnter
protocol SongDetailPresenterProtocol {
    var view: SongDetailsViewProtocol? { get set }
    var wireframe: SongDetailWireFrameProtocol? { get set }
    var song: SongModel? { get set }

    func viewDidLoad()

}

protocol SongDetailWireFrameProtocol {
    static func createSongDetailModule(forSong song: SongModel) -> UIViewController
}
