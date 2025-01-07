//
//  MusicLibraryView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/01/2025.
//

import SwiftUI

struct MusicLibraryView: View {
    @StateObject private var musicManager = MusicPlayerManager()
    
    var body: some View {
        NavigationStack {
            List(musicManager.musicLibrary, id: \.persistentID) { song in
                HStack {
                    VStack(alignment: .leading) {
                        Text(song.title ?? "Sans titre")
                            .font(.headline)
                        Text(song.artist ?? "Artiste inconnu")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        musicManager.playSong(song)
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .navigationTitle("Ma Bibliothèque")
            .onAppear {
                musicManager.requestAuthorization()
            }
        }
    }
}

#Preview {
    MusicLibraryView()
}
