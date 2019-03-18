//
//  CardView.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/20.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet weak var labelArtistName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        let nib = UINib(nibName: "CaptionableImageView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
//        contentView.frame = bounds
//        addSubview(contentMode)

    }
}
