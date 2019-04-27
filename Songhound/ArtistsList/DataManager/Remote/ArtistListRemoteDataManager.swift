//
// Created by Divine Dube on 2019-03-13.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Alamofire


class ArtistListRemoteDataManager: ArtistListRemoteDataManagerInputProtocolTwo {

    var remoteRequestHandler: ArtistListRemoteDataManagerOutputProtocol?

    func retrieveArtists() {
       // Alamofire
//                .request(Endpoints.ArtistsEnumEndpoints.fetch(artistName: "Swift").url)
//                .responseObject { (response: DataResponse<ModelResponse<ArtistModel>>) in
//                    switch response.result {
//                    case .success(let res):
//                        let artists = res.entityList
//                        self.remoteRequestHandler?.didRetrieveArtists(artists: artists!)
//                    case .failure(let error):
//                        self.remoteRequestHandler?.onError()
//                        print(error)
//                    }
//                }
    }

    func searchForSongName(songName: String, location: String) {
        Alamofire
                .request(Endpoints.ArtistsEnumEndpoints.fetch(songName: songName, location: location).url)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        let searchResults = try? JSONDecoder().decode(SearchModel.self, from: response.data!)
                         guard searchResults != nil else {
                            self.remoteRequestHandler?.onError()
                             return
                         }
                        self.remoteRequestHandler?.didRetrieveArtists(searchResults: searchResults!)
                    case .failure(let error):
                        self.remoteRequestHandler?.onError()
                        print(error)
                    }
                }
    }
}
