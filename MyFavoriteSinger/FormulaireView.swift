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
    
    var itemToEdit: Item? // Cette variable va contenir l'item à éditer
    
    @Environment(\.modelContext) private var modelContext // pour que la sauvgarde fonctionne
    @Environment(\.dismiss) private var dismiss // pour fermer la modal
    
    
    
    private func saveItem() {
            withAnimation {
                if let item = itemToEdit {
                    item.NameArtist = NameArtist
                    item.NameSong = NameSong
                } else {
                    // Gérer la création d'un nouvel item si nécessaire
                }
                do {
                    try modelContext.save()
                } catch {
                    print("Error saving item: \(error.localizedDescription)")
                }
                dismiss()
            }
        }

    
   


    
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
                       
                       Button(action: saveItem, label: {
                           Text("ajouter")
                       })

                      
                       } // fin section
                   } // fin form
            
            
            
            
            
            
        } // fin navigationview
        .onAppear {
                        if let item = itemToEdit {
                            NameArtist = item.NameArtist
                            NameSong = item.NameSong
                        }
                    }
        
        
        
        
        
        
        
        
        
        
        
    } // fin body
} // fin struct
#Preview {
    FormulaireView(NameArtist: "", NameSong: "")
}
