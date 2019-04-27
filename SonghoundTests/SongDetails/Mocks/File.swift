//
//  File.swift
//  SonghoundTests
//
//  Created by Divine Dube on 2019/04/27.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import UIKit
@testable import Songhound

class MockSongDetailsView : SongDetailsViewProtocol {
    
    var presenter: SongDetailPresenterProtocol?
    var isShowingError: Bool = false
    var isNotLoading: Bool = false
    var isLoading: Bool = false
    var song: SongModel?
    
    func showError() {
        self.isShowingError = true
    }
    
    func hideLoading() {
        self.isNotLoading = true
    }
    
    func showSongsDetail(forSong song: SongModel) {
        self.song = song
    }
    func showLoading() {
        isLoading = true
    }
}

// this will be inherited by the presnter
class MockSongDetailPresenter: SongDetailPresenterProtocol {
    var wireframe: SongDetailWireFrameProtocol?
    var view: SongDetailsViewProtocol?
    var song: SongModel?
    
    var isViewLoaded: Bool = false
    func viewDidLoad() {
        self.isViewLoaded = true
    }
    
}

class MockSongDetailWireFrame: SongDetailWireFrameProtocol {
    static var didcreateSongDetailModule = false
    static func createSongDetailModule(forSong song: SongModel) -> UIViewController {
        didcreateSongDetailModule = true
        return UIViewController()
    }
}
