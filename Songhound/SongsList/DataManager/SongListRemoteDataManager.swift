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

class SongListRemoteDataManager : SongsListRemoteDataManagerInputProtocol {
    var remoteRequestHandler: SongsListRemoteDataManagerOutputProtocol?
    
    func retrieveSongsList() {
        Alamofire
            .request(Endpoints.Songs.fetch(songName: "swift").url, method: .get)
//            .validate() // no need for this but anyway..
            .responseObject { (response: DataResponse<SongModelResponse>) in
                switch response.result {
                case .success(let res):
                    let songs = res.songs!
                    self.remoteRequestHandler?.onSongsRetrieved(songs)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
