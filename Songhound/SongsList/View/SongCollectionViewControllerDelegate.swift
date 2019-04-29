//
//  SongCollectionViewControllerDelegate.swift
//  Songhound
//
//  Created by Divine Dube on 2019/04/29.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

let reuseIdentifier = "songCollectionCell"


class SongCollectionViewControllerDelegate: NSObject, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate {

    private var songList: [SongModel]?
    private var presenter: SongListPresenterProtocol?
    private var collectionView: UICollectionView


    init(presenter: SongListPresenterProtocol?, collectionView: UICollectionView) {
        self.presenter = presenter
        self.collectionView = collectionView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("colectiobV: numberOfSections")
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("colectiobV: numberOfItemsInSection\(songList?.count)")

        return songList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("colectionV: cell init")
        
        guard songList != nil else {
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongCollectionViewControllerCell
        cell.song = songList![indexPath.item]

        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard songList != nil else {
            return
        }
        presenter?.showSongDetail(forSong: songList![indexPath.row])
    }

    func reload(songList: [SongModel]) {
        self.songList = songList
        collectionView.reloadData()
    }



}
