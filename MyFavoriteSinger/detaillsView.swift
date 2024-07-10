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
    
    
    @State private var isShowingModal = false // modal

    

    
    
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                
                Text(NameArtist)
                    .italic()
                    .font(.system(size: 50))


                Text("votre chanson préféré est: ")
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
                    // action a mettre
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 30))
                }
                
                
                Button(action: {
                    isShowingModal.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.yellow)
                        .font(.system(size: 30))
                }
                .sheet(isPresented: $isShowingModal) {
                    FormulaireView(NameArtist: "", NameSong: "")
                }

                
                
                
               
                } // fin toolbargroup
            } // fin toolbargroupe
        
            
        
        
        
        
    } // fin body
}  // fin struct

#Preview {
    detaillsView(NameArtist: "", NameSong: "")
}
