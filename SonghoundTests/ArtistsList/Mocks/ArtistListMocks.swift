//
//  ArtistListMocks.swift
//  SonghoundTests
//
//  Created by Divine Dube on 2019/04/27.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

@testable import Songhound
import UIKit
import Alamofire

class MockArtistListWireFrame: ArtistListWireFrameProtocol {
    func presentSongDetailView(from view: ArtistListViewProtocol, forSong song: SearchModelValue) {
        
    }
    
    
    static func createArtistListModule() -> UIViewController {
        return UIViewController()
    }

}

class MockArtistsListInteractorOutput: ArtistsListInteractorOutputProtocol {
    var retrievedArtist: Bool = false
    var showingError: Bool = false

    func didRetrieveArtists(searchResults: SearchModel) {
        self.retrievedArtist = true
    }

    func onError() {
        showingError = true
    }
}

class MockArtistListRemoteDataManagerOutput: ArtistListRemoteDataManagerOutputProtocol {


    func didRetrieveArtists(searchResults: SearchModel) {
    }
    
    func onError() {
        
    }
}


class MockArtistListInteractorInput : ArtistListInteractorInputProtocol {
    var presenter: ArtistsListInteractorOutputProtocol?
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocolTwo?
    var location: String?
    var songName: String?

    func retrieveArtists() {
    
    }
    func searchForArtist(songName: String, location: String) {
        self.songName =  songName
        self.location =  location
    }
}

class MockArtistListPresenter: ArtistListPresenterProtocol {
    // has reference to the intractor
    // need methods to wireframe to
    var view: ArtistListViewProtocol?
    var interactor: ArtistListInteractorInputProtocol?
    var wireFrame: ArtistListWireFrameProtocol?
    
    // wireframe
    func presentSongDetails(song: SearchModelValue) {
    
    }
    func viewDidLoad() {
    
    }
    func searchForSongs(songName: String, location: String) {
    
    }
}

class MockArtistListView: ArtistListViewProtocol {
    
    var presenter: ArtistListPresenterProtocol?
    var isLoading: Bool?
    var isShowingError: Bool?
    var searchModel: SearchModel?


    
    func showError() {
        isShowingError = true
    }
    
    func hideLoading() {
        isLoading = false
    }
    
    // reference to the intermediator
    func showLoading() {
        isLoading = true
    }
    func showArtists(searchResults: SearchModel) {
        searchModel = searchResults

    }
}

class MockArtistListRemoteDataManagerInput: ArtistListRemoteDataManagerInputProtocolThree {

    var songName: String?
    var location: String?

    func retrieveArtists() {

    }

    func searchForSongName(songName: String, location: String) {
        self.songName = songName
        self.location = location
    }

    var remoteRequestHandler: Songhound.ArtistListRemoteDataManagerOutputProtocol? = nil
}




