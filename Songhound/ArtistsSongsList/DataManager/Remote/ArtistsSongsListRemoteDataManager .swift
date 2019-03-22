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

class ArtistsSongsListRemoteDataManager: ArtistListRemoteDataManagerInputProtocol {
    var remoteRequestHandler: ArtistSongsListDataManagerOutputProtocol?

    func retrieveSongsList(artistName: String) {
        Alamofire
                .request(Endpoints.SongsEnumEndpoints.fetch(songName: artistName).url, method: .get)
                .responseObject { (response: DataResponse<ModelResponse<SongModel>>) in
                    switch response.result {
                    case .success(let res):
                        let songs = res.entityList!
                        self.remoteRequestHandler?.onArtistSongsListRetrieved(songs)
                    case .failure(let error):
                        self.remoteRequestHandler?.onError()
                        print(error)
                    }
                }
    }
}
