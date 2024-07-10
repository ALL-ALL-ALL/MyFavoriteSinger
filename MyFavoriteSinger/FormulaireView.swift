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
    
    
    
    // Fonction pour sauvegarder l'item
       private func saveItem() {
           withAnimation {
               if let item = itemToEdit {
                   // Modifier l'item existant
                   item.NameArtist = NameArtist
                   item.NameSong = NameSong
               } else {
                   // Ajouter un nouvel item
                   let newItem = Item(NameArtist: NameArtist, NameSong: NameSong)
                   modelContext.insert(newItem)
               }
               
               // Sauvegarder les modifications
               do {
                   try modelContext.save()
                   dismiss()
               } catch {
                   print("Error saving item: \(error.localizedDescription)")
               }
           }
       }


    
   
    var body: some View {
        
        NavigationView{
            
            
            
            
            Form {
                   Section {
                       TextField("Name of artiste", text: $NameArtist)
                       TextField("Name of song ", text: $NameSong)
                       Button(action: saveItem, label: {
                           Text("sauvegarder")
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
