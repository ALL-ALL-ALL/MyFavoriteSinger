//
//  ContentView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(NameArtist: "", NameSong: "")
            modelContext.insert(newItem)
        }
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    
    @State private var isShowingModal = false // modal

    
    
    
    
    

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                    } label: {
                        Image(systemName: "mic")
                        Text("Item at \(item.NameArtist)")
//                        Text("Item at \(item.NameSong)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                ToolbarItem {
                    Button("Afficher Modal") {
                                   isShowingModal.toggle()
                               }
                               .sheet(isPresented: $isShowingModal) {
                                   FormulaireView()
                               }
                           }
                

                
                
                
                
            }
        } detail: {
            Text("Select an item")
        }
        
        
        
        
        
        
        
        
        
        
        
    } // fin body
} // fin struct

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
