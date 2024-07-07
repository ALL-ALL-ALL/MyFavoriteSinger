//
//  FormulaireView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import SwiftUI

struct FormulaireView: View {
    @State private var NameArtist = ""
    @State private var NameSong = ""
    
    @Environment(\.modelContext) private var modelContext // pour que la sauvgarde fonctionne

    
    // obliger de mettre la fonction pour sauvegarder 
    private func addItem() {
        withAnimation {
            let newItem = Item(NameArtist: "", NameSong: "")
            modelContext.insert(newItem)
        }
    }

    var body: some View {
        
        NavigationView{
            
            
            
            
            Form {
                   Section {
                       TextField("Name of artiste", text: $NameArtist)
                       TextField("Name of song ", text: $NameSong)
                       Button(action: addItem, label: {
                           Text("sauvegarder")
                       })

                      
                       } // fin section
                   } // fin form
            
            
            
            
            
            
        } // fin navigationview
        
        
        
        
        
        
        
        
        
        
        
    } // fin body
} // fin struct
#Preview {
    FormulaireView()
}
