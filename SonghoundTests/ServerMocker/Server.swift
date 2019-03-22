//
// Created by Divine Dube on 2019-03-22.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation
import Swifter
/*
    create a singleton of this server object
*/
 class Server {

     private static var serverInstance: Server? = nil
     private var server: HttpServer!

     private init() {
        server = HttpServer()
         do {
             try server.start()
         } catch {
             print("error happened sorry")
         }
     }

     func fetchArtists(){
         server["/get_artists"] = { request in
             return HttpResponse.ok(.text("<html string>"))
         }
        // server.start()
     }

     func fetchSongs() {
         server["/get_songs"] = { request in
             return HttpResponse.ok(.text("<html string>"))
         }
     }

     static func getServerInstance() -> Server {
         if serverInstance == nil {
             serverInstance = Server()
         }
         return serverInstance!
     }
 }