//
//  tabView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 10/12/2024.
//

import SwiftUI

struct tabView: View {
    var body: some View {
        
        
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
            

            
        } // fin tabview
        
        .accentColor(Color.red)

        
        
        
        
        
        
        
        
        
        
        
    } // fin body
} // fin struct

#Preview {
    tabView()
}
