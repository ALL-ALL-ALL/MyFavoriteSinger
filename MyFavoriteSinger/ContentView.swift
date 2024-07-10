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
        NavigationView {
            
            ZStack {
                
//                Color.black.ignoresSafeArea()

                VStack {
                    
                            if items.isEmpty {
                                VStack {
                                    Image(systemName: "mic")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 150))
                                        .padding(.top,-140)
                                } // fin vstack
                                

                                VStack{
                                    Text("Aucun artiste dans votre liste")
//                                        .foregroundStyle(.white)
                                        .font(.title2)
                                        .bold()
                                        .italic()
                                } // fin vstack
                                
                            } else {
                                List {
                                    ForEach(items) { item in
                                        NavigationLink(destination: detaillsView(NameArtist: item.NameArtist, NameSong: item.NameSong, item: item)) {
                                            
                                            Image(systemName: "mic")
                                                .font(.system(size: 40))

                                            VStack(alignment: .leading) {
                                                Text(item.NameArtist)
                                                    .font(.system(size: 20))
                                            }
                                        }
                                    }
                                    .onDelete(perform: deleteItems)
                                } // fin de list
                            } // fin de sinon
                        } // fin vstack (si sinon)
                
                
                        .navigationTitle("Mes Artistes")
                        
                
                        
                        
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Button(action: {
                                    isShowingModal.toggle()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 30))
                                }
                                .sheet(isPresented: $isShowingModal) {
                                    FormulaireView(NameArtist: "", NameSong: "")
                                        .environment(\.modelContext, modelContext)
                                } // fin sheet
                            } // fin toolbargroupe
                            
                    } // fin toolbar
                
            } // fin zstack
            

                } // fin navigatiionview
        
        

        
        
        
            } // fin body
        } // fin struct


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
