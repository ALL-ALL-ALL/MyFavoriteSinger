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
    static let shared = MusicPlayerManager()
    
    @Published var musicLibrary: [MPMediaItem] = []
    @Published var selectedSongs: [MPMediaItem] = []
    @Published var currentSong: MPMediaItem?
    @Published var isPlaying: Bool = false

    
    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    // Rendre le constructeur internal (accessible)
    internal init() {}
    
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
        if currentSong != song {
            currentSong = song
            musicPlayer.stop()
            musicPlayer.setQueue(with: MPMediaItemCollection(items: [song]))
            musicPlayer.play()
            isPlaying = true
        } else {
            togglePlayPause()
        }
    }
    
    func pauseSong() {
        musicPlayer.pause()
        isPlaying = false
    }
    
    func resumeSong() {
        musicPlayer.play()
        isPlaying = true
    }
    
    func togglePlayPause() {
        isPlaying ? pauseSong() : resumeSong()
    }
}
