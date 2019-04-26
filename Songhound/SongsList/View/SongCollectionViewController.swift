//
//  SongCollectionViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/04/23.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

private let reuseIdentifier = "songCollectionCell"

class SongCollectionViewController: UIView {
    
    @IBOutlet weak var collectionVieww: UICollectionView!
    let cellSpacing: CGFloat = 0.6
    
    
    // we have an array of songs
    var songs: [SongModel] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }

     func initSubViews() {
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellSpacing)
        let cellHeight = floor(screenSize.height * cellSpacing)
        
        let insetX = (frame.width - cellWidth) / 2.0
        let insertY = (frame.height - cellHeight) / 2.0
        
        let layout = collectionVieww.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionVieww.contentInset = UIEdgeInsets(top: insertY, left: insetX, bottom: insertY, right: insetX)
        collectionVieww.dataSource = self
        collectionVieww.delegate = self
    }
}

extension SongCollectionViewController: UICollectionViewDataSource {
    
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongCollectionViewControllerCell
        cell.song = songs[indexPath.item]
        
        return cell
    }
    
    
}

extension SongCollectionViewController : UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionVieww.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
