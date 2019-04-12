//
// Created by Divine Dube on 2019-04-12.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import UIKit

extension SongsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewSongs.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        if let cell = cell as? SongTableViewCell {
            let song = songList[indexPath.row]
            cell.set(forSong: song)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showSongDetail(forSong: songList[indexPath.row])
    }
}