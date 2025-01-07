//
//  MusicPlayerManager.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/01/2025.
//

import Foundation
import MediaPlayer
import SwiftUI


class MusicPlayerManager: ObservableObject {
    @Published var musicLibrary: [MPMediaItem] = []
    @Published var selectedSongs: [MPMediaItem] = []
    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    func requestAuthorization() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    self.loadMusicLibrary()
                }
            }
        }
    }
    
    func loadMusicLibrary() {
        let query = MPMediaQuery.songs()
        if let songs = query.items {
            DispatchQueue.main.async {
                self.musicLibrary = songs
            }
        }
    }
    
    func playSong(_ song: MPMediaItem) {
        musicPlayer.stop()
        musicPlayer.setQueue(with: MPMediaItemCollection(items: [song]))
        musicPlayer.play()
    }
}


