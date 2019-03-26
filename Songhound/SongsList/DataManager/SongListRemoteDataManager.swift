//
//  SongListRemoteDataManager.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/02.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class SongListRemoteDataManager: SongsListRemoteDataManagerInputProtocol {
    // this protocol is the one responsible for sending data the presenter
    var remoteRequestHandler: SongsListRemoteDataManagerOutputProtocol?

    func retrieveSongsList(path: String) {
        print("the path in big boss \(path)")
        Alamofire
                .request(path, method: .get)
                .responseObject { (response: DataResponse<ModelResponse<SongModel>>) in
                    switch response.result {
                    case .success(let res):
                        if let songs = res.entityList {
                            self.remoteRequestHandler?.onSongsRetrieved(songs)
                        } else {
                            // should probably pass back an error type yoh
                            self.remoteRequestHandler?.onError()
                        }
                    case .failure(let error):
                        print(error)
                        self.remoteRequestHandler?.onError()
                    }
                }
    }
}
