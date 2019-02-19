//
//  UIUtils.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/19.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

func makeUIImageViewCircle(imageView: UIImageView, imgSize: Int) {
        imageView.layer.cornerRadius = CGFloat(imgSize / 2)
        imageView.layer.masksToBounds = true;
}


