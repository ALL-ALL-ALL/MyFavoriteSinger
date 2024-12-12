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
                   ScrollView {
                       ForEach(brands) { brand in
                           if let webRadios = brand.webRadios, !webRadios.isEmpty {
                               Section(header: Text(brand.title)) {
                                   ForEach(webRadios) { webRadio in
                                       WebRadioRow(webRadio: webRadio)
                                       Divider()
                                           .background(Color.gray)
                                           .padding(.horizontal)
                                   }
                               }
                           }
                       }
                   }
                   .background(Color.white)
                   .cornerRadius(10)
                   .padding(.horizontal)
                   .padding(.vertical, 5)
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
                       self.brands = brandsData.brands.filter { $0.webRadios?.isEmpty == false }
                       print("✅ Marques avec webradios chargées : \(self.brands.count)")
                       
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

struct ModalView: View {
   let webRadio: WebRadio
   @Environment(\.dismiss) var dismiss
   
   func getImageName(for webRadioId: String) -> String {
       let imageMapping: [String: String] = [
           "FRANCEINTER_LA_MUSIQUE_INTER": "1",
           "FRANCEMUSIQUE_CLASSIQUE_EASY": "2",
           "FRANCEMUSIQUE_CLASSIQUE_PLUS": "3",
           "FRANCEMUSIQUE_CONCERT_RF": "4",
           "FRANCEMUSIQUE_OCORA_MONDE": "5",
           "FRANCEMUSIQUE_LA_JAZZ": "6",
           "FRANCEMUSIQUE_LA_CONTEMPORAINE": "7",
           "FRANCEMUSIQUE_LA_BO": "8",
           "FRANCEMUSIQUE_LA_BAROQUE": "9",
           "FRANCEMUSIQUE_OPERA": "10",
           "FRANCEMUSIQUE_PIANO_ZEN": "11",
           "MOUV_100MIX": "12",
           "MOUV_CLASSICS": "13",
           "MOUV_DANCEHALL": "14",
           "MOUV_RNB": "15",
           "MOUV_RAPUS": "16",
           "MOUV_RAPFR": "17",
           "FIP_ROCK": "18",
           "FIP_JAZZ": "19",
           "FIP_GROOVE": "20",
           "FIP_WORLD": "21",
           "FIP_NOUVEAUTES": "22",
           "FIP_REGGAE": "23",
           "FIP_ELECTRO": "24",
           "FIP_METAL": "25",
           "FIP_POP": "26",
           "FIP_HIP_HOP": "27",
           "FRANCEBLEU_CHANSON_FRANCAISE": "28"
       ]
       return imageMapping[webRadioId] ?? "1"
   }
   
   var body: some View {
       NavigationView {
           VStack {
               Image(getImageName(for: webRadio.id))
                   .resizable()
                   .scaledToFit()
                   .frame(width: 200, height: 200)
                   .cornerRadius(12)
                   .padding()
               
               Text(webRadio.title)
                   .font(.title2)
                   .bold()
                   .padding(.top)
               
               if let description = webRadio.description {
                   Text(description)
                       .foregroundColor(.gray)
                       .padding()
                       .multilineTextAlignment(.center)
               }
               
               Spacer()
           }
           .navigationBarItems(trailing: Button("Fermer") {
               dismiss()
           })
       }
   }
}

struct WebRadioRow: View {
   let webRadio: WebRadio
   @State private var player: AVPlayer?
   @State private var isPlaying = false
   @State private var showModal = false
   
   func getImageName(for webRadioId: String) -> String {
       print("ID reçu pour image : \(webRadioId)")
       
       let imageMapping: [String: String] = [
           "FRANCEINTER_LA_MUSIQUE_INTER": "1",
           "FRANCEMUSIQUE_CLASSIQUE_EASY": "2",
           "FRANCEMUSIQUE_CLASSIQUE_PLUS": "3",
           "FRANCEMUSIQUE_CONCERT_RF": "4",
           "FRANCEMUSIQUE_OCORA_MONDE": "5",
           "FRANCEMUSIQUE_LA_JAZZ": "6",
           "FRANCEMUSIQUE_LA_CONTEMPORAINE": "7",
           "FRANCEMUSIQUE_LA_BO": "8",
           "FRANCEMUSIQUE_LA_BAROQUE": "9",
           "FRANCEMUSIQUE_OPERA": "10",
           "FRANCEMUSIQUE_PIANO_ZEN": "11",
           "MOUV_100MIX": "12",
           "MOUV_CLASSICS": "13",
           "MOUV_DANCEHALL": "14",
           "MOUV_RNB": "15",
           "MOUV_RAPUS": "16",
           "MOUV_RAPFR": "17",
           "FIP_ROCK": "18",
           "FIP_JAZZ": "19",
           "FIP_GROOVE": "20",
           "FIP_WORLD": "21",
           "FIP_NOUVEAUTES": "22",
           "FIP_REGGAE": "23",
           "FIP_ELECTRO": "24",
           "FIP_METAL": "25",
           "FIP_POP": "26",
           "FIP_HIP_HOP": "27",
           "FRANCEBLEU_CHANSON_FRANCAISE": "28"
       ]
       return imageMapping[webRadioId] ?? "1"
   }
   
   var body: some View {
       HStack {
           Button {
               showModal = true
           } label: {
               Image(getImageName(for: webRadio.id))
                   .resizable()
                   .scaledToFit()
                   .frame(width: 90, height: 90)
                   .cornerRadius(8)
                   .padding()
           }
           .sheet(isPresented: $showModal) {
               ModalView(webRadio: webRadio)
           }
           
           VStack(alignment: .leading, spacing: 5) {
               Text(webRadio.title)
                   .font(.headline)
                   .padding(.vertical, 70)
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
   }
}

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
