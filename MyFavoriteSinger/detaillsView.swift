//
//  detaillsView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 08/07/2024.
//

import SwiftUI
import SwiftData

struct detaillsView: View {
    var NameArtist: String
    var NameSong: String

    var item: Item 
    
    
    @State private var isShowingModal = false // modal

    @State private var showingAlter = false // message alerte (suprimer annuler)
    
    @Environment(\.modelContext) private var modelContext

    @Query private var items: [Item]

    
    private func deleteItem() {
           withAnimation {
               modelContext.delete(item)
           }
       }

    
    
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                
                Text(NameArtist)
                    .italic()
                    .font(.system(size: 50))


                Text("votre chanson préféré est: ")
                    .foregroundStyle(.red)
                    .font(.title2)
                    .bold()
                
                HStack {
                    Image(systemName: "music.mic")
                        .font(.system(size: 30))
                        .foregroundColor(.yellow)
                    
                    Text(NameSong)
                        .italic()
                        .font(.system(size: 50))

                } // fin hstack
            } // vstack
        } // Fin navigationstack

        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAlter = true
                }) {
                    
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 30))
                    
                } // fin button -
                
                .alert("important message", isPresented: $showingAlter) {
                  
                    Button("Supprimer", role: .destructive) {
                        
                       deleteItem()
                    }
                    
                    Button("Annuler", role: .cancel) { }

                }message: {
                    Text("êtes-vous sur de vouloir suprimer \(item.NameArtist) ? cette action est irreversible.")
                } // fin de message
                
                
                
                
                
                
                
                Button(action: {
                    isShowingModal.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.yellow)
                        .font(.system(size: 30))
                }
                .sheet(isPresented: $isShowingModal) {
                    FormulaireView(NameArtist: item.NameArtist, NameSong: item.NameSong, itemToEdit: item)
                    
                } // fin de sheet
            } // fin toolbargroup
        } // fin toolbargroupe
        
            
    } // fin body
}  // fin struct

#Preview {
    detaillsView(NameArtist: "", NameSong: "", item: Item(NameArtist: "", NameSong: ""))
//    (items : Item(NameArtist: "Sample Artist", NameSong: "Sample Song"))
}
