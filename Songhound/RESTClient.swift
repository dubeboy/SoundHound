//
// Created by Divine Dube on 2019-02-25.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//


import Alamofire
import SwiftyJSON



func getArtist(songId: Int) {

}

func getSongsForArtist(artist: Artist) {
    Alamofire.request("")
            .responseJSON(completionHandler: { response in
                let jsonResponse = JSON(response)

            })
}