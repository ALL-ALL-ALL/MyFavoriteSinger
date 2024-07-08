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
    

    
    
    
    
    var body: some View {
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
        
       
        
    
        
        
        
        
        
        
    }  // fin body
} // fin struct

#Preview {
    detaillsView(NameArtist: "", NameSong: "")
}
