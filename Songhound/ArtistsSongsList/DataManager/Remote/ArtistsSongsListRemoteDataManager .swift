//
//  ArtistsSongsListRemoteDataManager .swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/06.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class ArtistsSongsListRemoteDataManager: ArtistListRemoteDataManagerInputProtocol  {
    var remoteRequestHandler: ArtistSongsListDataManagerOutputProtocol?
    
    func retriveSongsList() {
        let artistName = ""
        Alamofire
            .request(Endpoints.Songs.fetch(songName: artistName).url, method: .get)
            .responseObject { (response: DataResponse<SongModelResponse>) in
                switch response.result {
                case .success(let res):
                    let songs = res.songs!
                    self.remoteRequestHandler?.onArtistSongsListRetrieved(songs)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
