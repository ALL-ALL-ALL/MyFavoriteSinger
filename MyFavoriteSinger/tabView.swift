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
        ZStack {
            // Affichage du contenu principal selon l'onglet la vue sélectionné
            
                switch selectedIndex {
                    
                case 0:
                    ContentView()
                case 1:
                    radioView()
                case 2:
                    MusicLibraryView()
                default:
                    tabView(webRadio: webRadio)
                }
            
//            Rectangle()
//                           .frame(width: 400, height: 200)
//                           .padding(.top,800)
             
            
            VStack {
                Spacer()
                
                // Barre de navigation personnalisée
                
                HStack(spacing: 50) {
                    
                    // Bouton Accueil
                    Button {
                        selectedIndex = 0
                    } label: {
                        Image(systemName: "house")
                            .font(.system(size: 25))
                    }

                    
                    
                    // Bouton Radio
                    Button {
                        selectedIndex = 1

                    } label: {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 25))

                    }
                    
                    
                    // Bouton Bibliothèque
                    Button {
                        selectedIndex = 2

                    } label: {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 25))

                    }
                    
                } // fin hstak
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    .frame(width: 400, height: 225)
                    .ignoresSafeArea())
            }// fin vstack
            
            // CapsuleView pour le lecteur
            VStack {
                CapsuleView(webRadio: audioManager.currentRadio ?? WebRadio(id: "", title: "", description: nil, liveStream: nil, playerUrl: nil, image: nil))
            }
            .padding(.top, 599)
        } // fin zstack
        
        
        
    } // fin body
} // fin struc



#Preview {
    tabView(webRadio: WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}
