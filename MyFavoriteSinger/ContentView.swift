//
//  ContentView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TopChartsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.red)
                        .frame(width: 420 , height: 220)
                        .overlay(
                            VStack {
                                Text("Obtenez 3 mois pour le")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                                Text("prix d'un")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                            }
                        )
                    
                    
                    Text("DÉCOUVERTES")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    ScrollView(.horizontal){
                        HStack(spacing: 15) {
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
                                        .frame(width: 200, height: 200)
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
                                        perspective: 0.5
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
            .padding(.top,30)


            .onAppear {
                viewModel.fetchTopTracks()
            }
            
            
            
        } // fin navigation stack
    
    } // fin body
} // fin struct
#Preview {
    ContentView()
}
