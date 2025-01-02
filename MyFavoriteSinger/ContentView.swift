//
//  ContentView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import SwiftUI
import AVKit 

struct ContentView: View {
    @StateObject private var viewModel = TopChartsViewModel()
    @StateObject private var spotifyViewModel = SpotifyViewModel()
    @State private var audioPlayer: AVPlayer?
    @State private var currentArtistIndex = 1

    
    func changeArtist() {
        currentArtistIndex = Int.random(in: 0..<spotifyViewModel.artists.count)
    }
    // en mode random
    
    
    func playPreview(for artistId: String) {
        SpotifyService.getSpotifyToken { token in
            guard let token = token else { return }
            SpotifyService.fetchTopTrack(artistId: artistId, token: token) { previewUrl in
                guard let previewUrl = previewUrl, let url = URL(string: previewUrl) else { return }
                DispatchQueue.main.async {
                    self.audioPlayer = AVPlayer(url: url)
                    self.audioPlayer?.play()
                }
            }
        }
    }

 


    
    var body: some View{
        
        NavigationStack{
                       
                   ScrollView{
                       
                       VStack{
                           ZStack{
                               LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                      .frame(width: 420, height: 220)
                               HStack {
                                   if currentArtistIndex < spotifyViewModel.artists.count {
                                       let currentArtist = spotifyViewModel.artists[currentArtistIndex]
                                       
                                       VStack(alignment: .leading, spacing: 10){
                                           Text("FOCUS ARTISTE")
                                               .font(.headline)
                                               .foregroundStyle(.white)
                                           
                                           Text(currentArtist.name)
                                               .font(.title.bold())
                                               .foregroundStyle(.white)
                                           
                                           Text("Followers:\(currentArtist.followers.total.formatted())")
                                               .foregroundStyle(.white)
                                               .font(.headline)
                                           
                                           Text("Genre")
                                               .foregroundStyle(.white.opacity(0.8))
                                           
                                           
                                           Text(currentArtist.genres.first ?? "")
                                               .font(.title3.bold())
                                               .foregroundStyle(.white)
                                               .padding(.top,-5)
                                       
                                       
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
                                       
                                       AsyncImage(url: URL(string:currentArtist.images.first?.url ?? "")) { image in
                                           image.resizable().aspectRatio(contentMode: .fill)
                                       } placeholder: {
                                           Color.gray
                                       }
                                       .frame(width: 105, height: 105)
                                       .clipShape(Circle())
                                       .padding(.trailing,80)
                                       
                                   }
                                           
                                           
                                           
                                           

                                   } // fin if let
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
                       } // fin scrollview
                   } // fin navigation stack
                   .navigationTitle("ACCUEIL")
//                   .padding(.bottom,40)
                   .onAppear {
                       viewModel.fetchTopTracks()
                       spotifyViewModel.fetchTopArtists()
                       
                       Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                           changeArtist()
                       }


                   }
               } // fin navigation stack
           } // fin body



#Preview {
    ContentView()
}


//.rotation3DEffect(
//    Angle(degrees: Double((geometry.frame(in: .global).minX - 100) / 5)),
//    axis: (x: 0, y: -1, z: 0),
//    anchor: .center,
//    perspective: 0.5
//    )



//Text("FOCUS ARTISTE")
//    .font(.headline)
//    .foregroundStyle(.white.opacity(0.8))
//
//Text("james blunt")  // Exemple d'artiste
//    .font(.title.bold())
//    .foregroundStyle(.white)
//
//Text("Nouveau single")
//    .foregroundStyle(.white.opacity(0.8))
//Text("Back To Bedlam")  // Nom du titre
//    .font(.title3.bold())
//    .foregroundStyle(.white)

//Circle()
//    .fill(.white.opacity(0.2))
//    .frame(width: 100, height: 100)
//    .overlay(
//        Image(systemName: "person.fill")
//            .font(.system(size: 50))
//            .foregroundColor(.white)
//    )




//VStack{
//    if let firstArtist = spotifyViewModel.artists.first {
//        Text(firstArtist.name)
//            .font(.title)
//            .foregroundColor(.white)
//        
//        Text(firstArtist.genres.first ?? "")
//            .font(.subheadline)
//            .foregroundColor(.white)
//        
        
//} // fin vstack
//
//
//    
//    
//    
//    
//} // fin if let
