//
//  ContentView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TopChartsViewModel()

    
    var body: some View{
        
        NavigationStack{
                       
                   ScrollView{
                       
                       VStack{
                           ZStack{
                               LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                      .frame(width: 420, height: 220)
                                  
                                  HStack {
                                      
                                      VStack(alignment: .leading, spacing: 10){
                                          Text("FOCUS ARTISTE")
                                              .font(.headline)
                                              .foregroundStyle(.white.opacity(0.8))
                                          
                                          Text("james blunt")  // Exemple d'artiste
                                              .font(.title.bold())
                                              .foregroundStyle(.white)
                                          
                                          Text("Nouveau single")
                                              .foregroundStyle(.white.opacity(0.8))
                                          Text("Back To Bedlam")  // Nom du titre
                                              .font(.title3.bold())
                                              .foregroundStyle(.white)
                                          
                                          Button(action: {
                                              // Action pour écouter
                                          }) {
                                              HStack {
                                                  Image(systemName: "play.fill")
                                                  Text("Écouter")
                                              }
                                              .padding(.horizontal, 20)
                                              .padding(.vertical, 8)
                                              .background(.white)
                                              .foregroundColor(.blue)
                                              .cornerRadius(20)
                                          }
                                          
                                      } // fin vstack
                                      .padding()
                                      Spacer()
                                      // Image de l'artiste (à droite)
                                      
                                      Circle()
                                          .fill(.white.opacity(0.2))
                                          .frame(width: 100, height: 100)
                                          .overlay(
                                              Image(systemName: "person.fill")
                                                  .font(.system(size: 50))
                                                  .foregroundColor(.white)
                                          )
                                          .padding()

                                      } // fin hstack
                               } // fin zstack
                           
                           
                          
                           
                           
                           Text("DÉCOUVERTES")
                               .font(.title)
                               .bold()
                               .frame(maxWidth: .infinity, alignment: .leading)
                               .padding(.horizontal,25)

                           
                           ScrollView(.horizontal){
                               HStack(spacing:-15) {
                                   ForEach(viewModel.tracks) { track in
                                       GeometryReader { geometry in
                                           VStack(alignment: .leading) {
                                               AsyncImage(url: URL(string: track.artworkUrl100)) { image in
                                                   image
                                                       .resizable()
                                                       .aspectRatio(contentMode: .fill)
                                               } placeholder: {
                                                   Color.gray
                                               }
                                               .frame(width: 180, height: 200)
                                               .clipShape(RoundedRectangle(cornerRadius: 10))
                                               
                                               Text(track.trackName)
                                                   .font(.headline)
                                                   .lineLimit(1)
                                               Text(track.artistName)
                                                   .foregroundColor(.gray)
                                           } // fin vstack
                                           
                                           .rotation3DEffect(
                                               Angle(degrees: Double((geometry.frame(in: .global).minX - 100) / 5)),
                                               axis: (x: 0, y: -1, z: 0),
                                               anchor: .center,
                                               perspective: 0.2
                                               )
                                           
                                       } // fin geometry reader
                                       .frame(width: 200, height: 260)
                                   } // fin foreach
                               } // hstack
                               .padding(.horizontal)
                           } // fin scroll view horizontal
                       } // fin Vstack
                   } // fin scroll view
                   .navigationTitle("ACCUEIL")
//                   .padding(.bottom,40)
                   .onAppear {
                       viewModel.fetchTopTracks()
                   }
               } // fin navigation stack
           } // fin body
       } // fin struct



#Preview {
    ContentView()
}


//.rotation3DEffect(
//    Angle(degrees: Double((geometry.frame(in: .global).minX - 100) / 5)),
//    axis: (x: 0, y: -1, z: 0),
//    anchor: .center,
//    perspective: 0.5
//    )
