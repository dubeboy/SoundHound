//
// Created by Divine Dube on 2019-02-25.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class User : NSCoder {
    var userId: String?
    var idToken: String?
    var fullName: String?
    var givenName: String?
    var familyName: String?
    var email: String?

    init(userId: String?, idToken: String?, fullName: String?, givenName: String?, familyName: String?, email: String?) {
        self.userId = userId
        self.idToken = idToken
        self.fullName = fullName
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
    
    //try this new property watchers


}
