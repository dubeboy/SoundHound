//
// Created by Divine Dube on 2019-04-12.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

extension SongsListViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error!) {
        print("oopps user signed out yoh")

        guard let user = user, let authentication = user.authentication else {
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("user not signed in there was an error bro \(error)")
                return
            }
            print("Yey user signed in bro")
            self.saveGoogleUserInfo(user: user)
            print("the user is \(String(describing: user.userID))")
            if let user = getSignedInUser() {
                self.lblUserName.text = user.fullName
                if let profileUrl = user.profileURL {
                    self.imgProfilePicture.dowloadFromServer(link: profileUrl)
                } else {
                    // TODO: I want to set a default image
                    // leave it as is the defualt image will be set  ie wont change
                }
            } else {
                print("failed to load user man")
                self.lblUserName.text = ""
            }
        }
    }

    private func saveGoogleUserInfo(user: GIDGoogleUser) {
        let userId = user.userID
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        print("this user has profile picture \(user.profile.hasImage)")
        let profileURL = user.profile.imageURL(withDimension: 0).absoluteString
        let preferences = UserDefaults.standard

        preferences.set(userId, forKey: USER_ID)
        preferences.set(idToken, forKey: ID_TOKEN)
        preferences.set(fullName, forKey: FULL_NAME)
        preferences.set(givenName, forKey: GIVEN_NAME)
        preferences.set(familyName, forKey: FAMILY_NAME)
        preferences.set(email, forKey: EMAIL)
        preferences.set(profileURL, forKey: PROFILE_URL)

        let sync = preferences.synchronize()
        print("it sycned \(sync)")
    }
}


