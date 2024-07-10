//
//  FormulaireView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import SwiftUI
import SwiftData

struct FormulaireView: View {
    @State  var NameArtist : String
    @State  var NameSong :String
    
    @Environment(\.modelContext) private var modelContext // pour que la sauvgarde fonctionne
    @Environment(\.dismiss) private var dismiss // pour fermer la modal
    
    
    var itemToEdit: Item?
    
    // pour modifier item deja existant
    private func saveItem() {
            withAnimation {
                if let item = itemToEdit {
                    item.NameArtist = NameArtist
                    item.NameSong = NameSong
                } else {
                    let newItem = Item(NameArtist: NameArtist, NameSong: NameSong)
                    modelContext.insert(newItem)
                }
                try? modelContext.save()
                dismiss()
            }
        } // Fin func
    
   


    
    // obliger de mettre la fonction pour sauvegarder 
    private func addItem() {
        withAnimation {
            let newItem = Item(NameArtist: NameArtist, NameSong: NameSong)
            modelContext.insert(newItem)
            try? modelContext.save() // Sauvegarder les modifications
            dismiss() // Fermer la modal

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
    FormulaireView(NameArtist: "DISIZ", NameSong: "la bête")
}
