//
// Created by Divine Dube on 2019-03-13.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Alamofire

class ArtistListRemoteDataManager: ArtistListRemoteDataManagerInputProtocol2 {

    var remoteRequestHandler: ArtistListRemoteDataManagerOutputProtocol?

    func retrieveArtists() {
        Alamofire
                .request(Endpoints.ArtistsEnumEndpoints.fetch(artistName: "Swift").url)
                .responseObject { (response: DataResponse<ModelResponse<ArtistModel>>) in
                    switch response.result {
                    case .success(let res):
                        let artists = res.entityList
                        self.remoteRequestHandler?.didRetrieveArtists(artists: artists!)
                    case .failure(let error):
                        self.remoteRequestHandler?.onError()
                        print(error)
                    }
                }
    }

    func searchForArtist(artistName: String) {
        Alamofire
                .request(Endpoints.ArtistsEnumEndpoints.fetch(artistName: artistName).url)
                .responseObject { (response: DataResponse<ModelResponse<ArtistModel>>) in
                    switch response.result {
                    case .success(let res):
                        let artists = res.entityList
                        self.remoteRequestHandler?.didRetrieveArtists(artists: artists!)
                    case .failure(let error):
                        self.remoteRequestHandler?.onError()
                        print(error)
                    }
                }
    }
}
