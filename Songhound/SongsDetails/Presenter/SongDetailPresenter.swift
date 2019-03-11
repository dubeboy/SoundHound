//
// Created by Divine Dube on 2019-03-11.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class SongDetailPresenter : SongDetailPresenterProtocol{
    var view: SongDetailsViewProtocol?
    var wireframe: SongDetailWireFrameProtocol?
    var song: SongModel?

    func viewDidLoad() {
        view?.showSongsDetail(forSong: song!)
    }
}
