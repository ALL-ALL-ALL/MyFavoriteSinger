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
   let image: String?
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
                       
                       // Afficher les IDs pour le débogage
                       for brand in self.brands {
                           print("🎯 Brand: \(brand.title)")
                           if let webRadios = brand.webRadios {
                               for radio in webRadios {
                                   print("📻 Radio ID: \(radio.id)")
                               }
                           }
                       }
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
   
   // Fonction pour obtenir le nom de l'image correspondante
    func getImageName(for webRadioId: String) -> String {
        // Affichons l'ID pour le débogage
        print("ID reçu pour image : \(webRadioId)")
        
        let imageMapping: [String: String] = [
            "La musique d'inter": "1",
            "Classique Easy": "2",
            "Classique Plus": "3",
            "Concerts Radio france ": "4",
            "Ocora Musique du Monde ": "5",
            "La Jazz": "6",
            "La Contemporaine": "7",
            "Musique De Films": "8",
            "La Baroque": "9",
            "Opera": "10",
            "Pianno Zen": "11",
            "Mouv 100% mix": "12",
            "Mouv'classique": "13",
            "Mouv'DanceHall": "14",
            "Mouv'RnB & soul": "15",
            "Mouv'Rap Us": "16",
            "Mouv'Rap français": "17",
            "FIP Rock": "18",
            "FIP Jazz": "19",
            "FIP Groove": "20",
            "FIP monde": "21",
            "FIP Nouveautés": "22",
            "FIP Reggae": "23",
            "FIP Electro": "24",
            "FIP Metal": "25",
            "FIP Pop": "26",
            "FIP Hip-Hop ": "27",
            "100% chanson française": "28",














            
            
           


            // Ajoutez les autres jusqu'à 28
            "DEFAULT": "28" // Dernière image comme fallback
        ]
        
        // Retournons l'image correspondante ou la première par défaut
        return imageMapping[webRadioId] ?? "1"
    }
   
   var body: some View {
       HStack {
           Image(getImageName(for: webRadio.id))
               .resizable()
               .scaledToFit()
               .frame(width: 60, height: 60)
               .cornerRadius(8)
               .padding()
           
           VStack(alignment: .leading, spacing: 4) {
               Text(webRadio.title)
                   .font(.headline)
               Text(webRadio.description ?? "")
                   .font(.subheadline)
                   .foregroundColor(.gray)
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
