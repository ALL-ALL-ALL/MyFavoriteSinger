//
//  tabView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 10/12/2024.
//

import SwiftUI

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
                
                bibliView()
                    .tabItem {
                        Label("Bibliothèque", systemImage: "music.note.list")
                        
                    }
                
                //            .accentColor(Color.red)
                
                
                
                
            } // fin tabview
            
                       VStack {
                           CapsuleView(webRadio: audioManager.currentRadio ?? WebRadio(id: "", title: "", description: nil, liveStream: nil, playerUrl: nil, image: nil))
                       } // fin vstack
                       .padding(.top, 600) // ne pas bouger
                   
        
    
            
        

            
            
            
            
        } // fin zstack
        
        
        
        
        
        
        
       
        
        
        
        
        
        

        
        
        
        
        
        
        
        
        
        
        
    } // fin body
    
} // fin struct

#Preview {
    tabView(webRadio: WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}
