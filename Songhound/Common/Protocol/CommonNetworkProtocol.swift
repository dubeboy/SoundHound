//
//  NetworkProtocol.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/04.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation

protocol CommonNetworkProtocol: class {
    // must be able to show a friendly error when it ocours so that we dont make our users cry
    func showError()
    // show that we loading some data
    func showLoading()
    // we want to be able to hide the loading progress bar
    func hideLoading()
}
