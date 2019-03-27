//
//  CustomArtistsView.swift
//  Songhound
//
//  Created by Divine Dube on 2019-03-26.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class CustomArtistsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var artistThree: UIImageView!
    @IBOutlet weak var artistTwo: UIImageView!
    @IBOutlet weak var artistOne: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }

    private func initSubViews() {
        let nib = UINib(nibName: "CustomArtistsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        // modify the constraints here
    }
}
