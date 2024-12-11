//
//  radioView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 10/12/2024.
//

import SwiftUI
import AVKit

// Structures
struct Brand: Identifiable, Codable {
   let id: String
   let title: String
   let webRadios: [WebRadio]?
}

struct WebRadio: Identifiable, Codable {
   let id: String
   let title: String
   let description: String?
   let liveStream: String?
   let playerUrl: String?
}

struct radioView: View {
   @State private var brands: [Brand] = []
   @State private var isLoading = true
   @State private var errorMessage: String?
   
   var body: some View {
       NavigationStack {
           VStack {
               if isLoading {
                   ProgressView("Chargement des webradios...")
               } else if let errorMessage = errorMessage {
                   VStack {
                       Text("Erreur : \(errorMessage)")
                           .foregroundColor(.red)
                           .padding()
                       Button("Réessayer") {
                           isLoading = true
                           loadBrands()
                       }
                       .padding()
                   }
               } else {
                   List(brands) { brand in
                       if let webRadios = brand.webRadios, !webRadios.isEmpty {
                           Section(header: Text(brand.title)) {
                               ForEach(webRadios) { webRadio in
                                   WebRadioRow(webRadio: webRadio)
                               }
                           }
                       }
                   }
               }
           }
           .navigationTitle("Webradios")
           .onAppear(perform: loadBrands)
       }
   }
   
   func loadBrands() {
       print("🚀 Début du chargement des webradios")
       
       guard let url = URL(string: "https://openapi.radiofrance.fr/v1/graphql") else {
           self.errorMessage = "URL invalide"
           self.isLoading = false
           return
       }
       
       let query = """
       {
           "query": "query { brands { id title webRadios { id title description liveStream playerUrl } } }"
       }
       """
       
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.setValue("8944d424-001c-4931-a3a0-6cc908ceec9a", forHTTPHeaderField: "X-Token")
       request.httpBody = query.data(using: .utf8)
       
       URLSession.shared.dataTask(with: request) { data, response, error in
           DispatchQueue.main.async {
               if let error = error {
                   self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                   self.isLoading = false
                   return
               }
               
               guard let data = data else {
                   self.errorMessage = "Aucune donnée reçue"
                   self.isLoading = false
                   return
               }
               
               do {
                   let decoder = JSONDecoder()
                   let response = try decoder.decode(GraphQLResponse.self, from: data)
                   
                   if let errors = response.errors, !errors.isEmpty {
                       let errorMessages = errors.map { $0.message }.joined(separator: ", ")
                       self.errorMessage = errorMessages
                   } else if let brandsData = response.data {
                       // Filtrer uniquement les marques qui ont des webradios
                       self.brands = brandsData.brands.filter { $0.webRadios?.isEmpty == false }
                       print("✅ Marques avec webradios chargées : \(self.brands.count)")
                   }
               } catch {
                   print("❌ Erreur de décodage : \(error)")
                   self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
               }
               
               self.isLoading = false
           }
       }.resume()
   }
}

// Vue pour afficher une webradio
struct WebRadioRow: View {
   let webRadio: WebRadio
   @State private var player: AVPlayer?
   @State private var isPlaying = false
   
   var body: some View {
       HStack {
           VStack(alignment: .leading) {
               Text(webRadio.title)
                   .font(.headline)
               
               if let description = webRadio.description {
                   Text(description)
                       .font(.subheadline)
                       .foregroundColor(.gray)
               }
           }
           
           Spacer()
           
           if let streamURL = webRadio.liveStream {
               Button(action: {
                   if isPlaying {
                       player?.pause()
                   } else {
                       player = AVPlayer(url: URL(string: streamURL)!)
                       player?.play()
                   }
                   isPlaying.toggle()
               }) {
                   Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                       .font(.title)
                       .foregroundColor(.blue)
               }
           }
       }
       .padding(.vertical, 5)
   }
}

// Structures pour le décodage
struct GraphQLResponse: Codable {
   let data: BrandsData?
   let errors: [GraphQLError]?
}

struct GraphQLError: Codable {
   let message: String
}

struct BrandsData: Codable {
   let brands: [Brand]
}

#Preview {
   radioView()
}
