//
//  tabView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 10/12/2024.
//

import SwiftUI
struct VisualEffectBlurView: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        return effectView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

struct tabView: View {
    @StateObject private var audioManager = AudioManager.shared
    
    let webRadio: WebRadio
    
    var body: some View {
        ZStack{
       

            TabView {
                
                
                ContentView()
                    .tabItem {
                        Label("Accueil", systemImage: "house")
                        
                    }
                
                radioView()
                    .tabItem {
                        Label("radio", systemImage: "dot.radiowaves.left.and.right")

                    }
                
                MusicLibraryView()
                    .tabItem {
                        Label("Bibliothèque", systemImage: "music.note.list")
                        

                        
                    }
                
                
                              
                
            } // fin tabview
            .background(
                       VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)  // Applique le flou ici
                           .offset(y: 700)
                   )
            .accentColor(Color.red)




            
            
//            VStack {
//                CapsuleView(webRadio: audioManager.currentRadio ?? WebRadio(id: "", title: "", description: nil, liveStream: nil, playerUrl: nil, image: nil))
//            } // fin vstack
//            .padding(.top, 599) // ne pas bouger

            
        } // fin zstack
        
        
        
        
        
        
        
    } // fin body
    
} // fin struct

#Preview {
    tabView(webRadio: WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}
