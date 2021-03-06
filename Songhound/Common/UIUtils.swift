//
//  UIUtils.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/19.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

let USER_ID = "user"
let ID_TOKEN = "id_token"
let FULL_NAME = "full_name"
let GIVEN_NAME = "given_name"
let FAMILY_NAME = "family_name"
let EMAIL = "email"
let PROFILE_URL = "profile_url"


func makeUIImageViewCircle(imageView: UIImageView, imgSize: Int) {
    imageView.layer.cornerRadius = CGFloat(imgSize / 2)
    imageView.layer.masksToBounds = true;
}


func getSignedInUser() -> User? {
    //its a singleton so it does not matter how many times it gets called / hit stuff /
    //TODO : rename to userDefaults
    let pref = UserDefaults.standard

    let userId = pref.string(forKey: USER_ID) ?? ""
    // this means a user is not signed in yoh
    guard !userId.isEmpty else {
        return nil
    }

    let idToken = pref.string(forKey: ID_TOKEN)
    let fullName = pref.string(forKey: FULL_NAME)
    let givenName = pref.string(forKey: GIVEN_NAME)
    let familyName = pref.string(forKey: FAMILY_NAME)
    let email = pref.string(forKey: EMAIL)
    let profileURL = pref.string(forKey: PROFILE_URL)

    let user = User(userId: userId,
            idToken: idToken,
            fullName: fullName,
            givenName: givenName,
            familyName: familyName,
            email: email,
            profileURL: profileURL)

    return user
}

