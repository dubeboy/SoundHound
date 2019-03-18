//
//  SongDetailsWireFrame.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/11.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class SongDetailsWireFrame: SongDetailWireFrameProtocol {
    class func createSongDetailModule(forSong song: SongModel) -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SongDetailViewController")
        if let view = viewController as? SongDetailViewController {
            var presenter: SongDetailPresenterProtocol = SongDetailPresenter()
            let wireFrame: SongDetailWireFrameProtocol = SongDetailsWireFrame()
//
//            view.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            view.navigationController?.navigationBar.shadowImage = UIImage()
//            view.navigationController?.navigationBar.isTranslucent = true
            //        view.navigationController?.navigationBar.backgroundColor = .blue

            view.presenter = presenter
            presenter.view = view
            presenter.song = song
            presenter.wireframe = wireFrame

            return viewController
        }
        return UIViewController()
    }

}
