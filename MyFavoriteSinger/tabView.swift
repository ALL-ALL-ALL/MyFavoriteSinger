//
//  tabView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 10/12/2024.
//

import SwiftUI


struct tabView: View {
    @StateObject private var audioManager = AudioManager.shared
    @State private var selectedIndex = 0
    let webRadio: WebRadio
    
    
    var body: some View {
        VStack {
            ZStack{
                TabView {
                    
                    ContentView()
                        .tabItem {
                            
                            Label("Accueil", systemImage: "house")
                        }
                        .toolbarBackground(Color.black, for: .tabBar)

                    
                    radioView()
                        .tabItem {
                            
                            Label("Radio", systemImage: "dot.radiowaves.left.and.right")
                        }
                        .toolbarBackground(Color.black, for: .tabBar)

                    
                    MusicLibraryView()
                        .tabItem {
                            
                            Label("Bibliothèque", systemImage: "music.house")
                        }
                        .toolbarBackground(.ultraThinMaterial, for: .tabBar)  // Effet de flou

                        .toolbarBackground(Color.black, for: .tabBar)

                    
                } // fin tabview
                .accentColor(Color.red)


            
                
                // CapsuleView pour le lecteur
                
                
                //                CapsuleView(webRadio: audioManager.currentRadio ?? WebRadio(id: "", title: "", description: nil, liveStream: nil, playerUrl: nil, image: nil))
                //
                //            .padding(.top, 599)
                
                
                
            } // fin de zstack
            
            
        } // fin Vstack
        
        
        
    } // fin body
} // fin struc



#Preview {
    tabView(webRadio: WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}
