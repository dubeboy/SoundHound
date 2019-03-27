//
// Created by Divine Dube on 2019-03-22.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation
import Swifter

/*
    create a singleton of this server object
*/

// swiftlint:disable line_length

class Server {

    private static var serverInstance: Server?
    private var server: HttpServer!

    // it would be expensive to recreate a server for each request
    private init() {
        self.getResource(withName: "songs")
        print("Starting server")
        server = HttpServer()
        fetchArtists()
        fetchSongs()
        fetchEmptySongsList()
        makeAnEmptyObject()
        makeErrorRequest()
        do {
            try server.start()
        } catch {
            print("error happened sorry could not start server bro")
        }
    }

    private func fetchArtists() {
        server["/get_artists"] = { request in
            return HttpResponse.ok(.text("{\n  \"resultCount\": 50,\n  \"results\": [\n    {\n      \"wrapperType\": \"artist\",\n      \"artistType\": \"Artist\",\n      \"artistName\": \"Taylor Swift\",\n      \"artistLinkUrl\": \"https://itunes.apple.com/us/artist/taylor-swift/159260351?uo=4\",\n      \"artistId\": 159260351,\n      \"amgArtistId\": 816977,\n      \"primaryGenreName\": \"Pop\",\n      \"primaryGenreId\": 14\n    },\n    {\n      \"wrapperType\": \"artist\",\n      \"artistType\": \"Artist\",\n      \"artistName\": \"Swift\",\n      \"artistLinkUrl\": \"https://itunes.apple.com/us/artist/swift/1147844711?uo=4\",\n      \"artistId\": 1147844711,\n      \"primaryGenreName\": \"Hip-Hop/Rap\",\n      \"primaryGenreId\": 18\n    }\n  ]\n}"))
        }
//        let filePath = Bundle.main.path(forResource: "artists", ofType: "json")
//        print("the file path: \(filePath ?? "nil")")
//        server["/get_artists"] = shareFile(filePath ?? "artists.json")
    }

    private func fetchSongs() {
        server["/get_songs"] = { request in
            return HttpResponse.ok(.text("{\n  \"resultCount\": 50,\n  \"results\": [\n    {\n      \"wrapperType\": \"track\",\n      \"kind\": \"song\",\n      \"artistId\": 159260351,\n      \"collectionId\": 1274999981,\n      \"trackId\": 1274999998,\n      \"artistName\": \"Taylor Swift\",\n      \"collectionName\": \"reputation\",\n      \"trackName\": \"Delicate\",\n      \"collectionCensoredName\": \"reputation\",\n      \"trackCensoredName\": \"Delicate\",\n      \"artistViewUrl\": \"https://itunes.apple.com/us/artist/taylor-swift/159260351?uo=4\",\n      \"collectionViewUrl\": \"https://itunes.apple.com/us/album/delicate/1274999981?i=1274999998&uo=4\",\n      \"trackViewUrl\": \"https://itunes.apple.com/us/album/delicate/1274999981?i=1274999998&uo=4\",\n      \"previewUrl\": \"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview118/v4/eb/72/97/eb7297b4-147b-ce5e-dec0-be880d926e3d/mzaf_2784605975265506901.plus.aac.p.m4a\",\n      \"artworkUrl30\": \"https://is2-ssl.mzstatic.com/image/thumb/Music128/v4/bc/84/77/bc847733-8fcd-1040-8ddb-4271601f4151/source/30x30bb.jpg\",\n      \"artworkUrl60\": \"https://is2-ssl.mzstatic.com/image/thumb/Music128/v4/bc/84/77/bc847733-8fcd-1040-8ddb-4271601f4151/source/60x60bb.jpg\",\n      \"artworkUrl100\": \"https://is2-ssl.mzstatic.com/image/thumb/Music128/v4/bc/84/77/bc847733-8fcd-1040-8ddb-4271601f4151/source/100x100bb.jpg\",\n      \"collectionPrice\": 7.99,\n      \"trackPrice\": 1.29,\n      \"releaseDate\": \"2017-11-10T08:00:00Z\",\n      \"collectionExplicitness\": \"notExplicit\",\n      \"trackExplicitness\": \"notExplicit\",\n      \"discCount\": 1,\n      \"discNumber\": 1,\n      \"trackCount\": 15,\n      \"trackNumber\": 5,\n      \"trackTimeMillis\": 232251,\n      \"country\": \"USA\",\n      \"currency\": \"USD\",\n      \"primaryGenreName\": \"Pop\",\n      \"isStreamable\": true\n    },\n    {\n      \"wrapperType\": \"track\",\n      \"kind\": \"song\",\n      \"artistId\": 159260351,\n      \"collectionId\": 907242701,\n      \"trackId\": 907242707,\n      \"artistName\": \"Taylor Swift\",\n      \"collectionName\": \"1989\",\n      \"trackName\": \"Shake It Off\",\n      \"collectionCensoredName\": \"1989\",\n      \"trackCensoredName\": \"Shake It Off\",\n      \"artistViewUrl\": \"https://itunes.apple.com/us/artist/taylor-swift/159260351?uo=4\",\n      \"collectionViewUrl\": \"https://itunes.apple.com/us/album/shake-it-off/907242701?i=907242707&uo=4\",\n      \"trackViewUrl\": \"https://itunes.apple.com/us/album/shake-it-off/907242701?i=907242707&uo=4\",\n      \"previewUrl\": \"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/Music3/v4/b8/b3/7a/b8b37a93-2154-34da-74fc-8e8a316979a8/mzaf_7991652075174454658.plus.aac.p.m4a\",\n      \"artworkUrl30\": \"https://is3-ssl.mzstatic.com/image/thumb/Music5/v4/29/fa/b6/29fab67f-c950-826f-26a0-5eebcd0e262b/source/30x30bb.jpg\",\n      \"artworkUrl60\": \"https://is3-ssl.mzstatic.com/image/thumb/Music5/v4/29/fa/b6/29fab67f-c950-826f-26a0-5eebcd0e262b/source/60x60bb.jpg\",\n      \"artworkUrl100\": \"https://is3-ssl.mzstatic.com/image/thumb/Music5/v4/29/fa/b6/29fab67f-c950-826f-26a0-5eebcd0e262b/source/100x100bb.jpg\",\n      \"collectionPrice\": 10.99,\n      \"trackPrice\": 1.29,\n      \"releaseDate\": \"2014-08-18T07:00:00Z\",\n      \"collectionExplicitness\": \"notExplicit\",\n      \"trackExplicitness\": \"notExplicit\",\n      \"discCount\": 1,\n      \"discNumber\": 1,\n      \"trackCount\": 13,\n      \"trackNumber\": 6,\n      \"trackTimeMillis\": 219209,\n      \"country\": \"USA\",\n      \"currency\": \"USD\",\n      \"primaryGenreName\": \"Pop\",\n      \"isStreamable\": true\n    }\n  ]\n}"))
        }
//        let filePath = Bundle.main.path(forResource: "songs", ofType: "json")
//        print("the file path: \(filePath ?? "nil")")
//        server["/get_songs"] = shareFile(filePath ?? "songs.json")
    }

    private func fetchEmptySongsList() {
        server["/get_empty"] = { request in
            return HttpResponse.ok(.text("{\n  \"resultCount\": 0,\n  \"results\": [\n]\n}"))
        }
    }

    private func makeAnEmptyObject() {
        server["/get_empty_object"] = { request in
            return HttpResponse.ok(.text("{}"))
        }
    }

    private func makeErrorRequest() {
        server["/error"] = { request in
            return HttpResponse.badRequest(.text("bad request"))
        }
    }

    private func getResource(withName name: String) -> String? {
        if let path = Bundle.main.path(forResource: "AppDelegate", ofType: "swift") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                print("the data is \(data.count)")
                let jsonString = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
                print("the string is \(jsonString)")
                return jsonString
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }

    static func getServerInstance() -> Server {
        if serverInstance == nil {
            serverInstance = Server()
        }
        return serverInstance!
    }
}
