//
//  tabView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 10/12/2024.
//

import SwiftUI
import MediaPlayer


struct tabView: View {
    
    @State private var selectedTab = 0
    
    @StateObject private var audioManager = AudioManager.shared
    let webRadio: WebRadio
    
    
    var body: some View {
        VStack {
            ZStack{
                
                TabView(selection: $selectedTab)  {
                    
                    
                    ContentView()
                        .tabItem {
                            
                            Label("Accueil", systemImage: "house")
                        }
                        .tag(0)
                    
                        .toolbarBackground(Color.black, for: .tabBar)
                    
                    
                    radioView()
                        .tabItem {
                            
                            Label("Radio", systemImage: "dot.radiowaves.left.and.right")
                        }
                        .tag(1)
                    
                        .toolbarBackground(Color.black, for: .tabBar)
                    
                    
                    MusicLibraryView()
                        .tabItem {
                            
                            Label("Bibliothèque", systemImage: "music.house")
                        }
                        .tag(2) 
                    
                        .toolbarBackground(Color.black, for: .tabBar)
                    
                    
                    
                    
                    
                } // fin tabview
                .toolbarBackground(.black, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .overlay(alignment: .bottom) {
                    // couverture qui masque la ligne de la tabview
                    Rectangle()
                        .fill(.black)
                        .frame(width: UIScreen.main.bounds.width, height: 56)
                        .offset(y: -44) 
                        .allowsHitTesting(false)
                } // fin overlay 
                
                
                
                
                
                
                
                
                
                
                
                
                
                .accentColor(Color.red)
                
                
                
                
                
                //         CapsuleView pour le lecteur
                
                
                CapsuleView(selectedTab: .constant(0), webRadio: audioManager.currentRadio ?? WebRadio(id: "", title: "", description: nil, liveStream: nil, playerUrl: nil, image: nil))
                
                    .padding(.top, 605)
                
                
                
            } // fin de zstack
            
            
        } // fin Vstack
        
        
        
    } // fin body
} // fin struc



#Preview {
    tabView(webRadio: WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}
