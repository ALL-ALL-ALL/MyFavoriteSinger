//
//  MusicLibraryView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/01/2025.
//

import SwiftUI

struct MusicLibraryView: View {
    @StateObject private var musicManager = MusicPlayerManager()
    @State private var isPlaying: Bool = false
    
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
                    } // fin vstack
                    
                    Spacer()
                    
                    Button(action: {
                        musicManager.playSong(song)
                    }) {
                        Image(systemName: musicManager.currentSong == song && musicManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title2)
                    }
                    
                    
                    
                } // fin hstack
            } // fin list
            .listStyle(PlainListStyle()) // Supprime le style par défaut de la liste
            .navigationTitle("Ma Bibliothèque")
            .onAppear {
                musicManager.requestAuthorization()
            }
            .padding(.bottom,50)

            
            
            
            
        } // fin navigationstack
        
        
    } // fin body
} // fin struct

#Preview {
    MusicLibraryView()
}
