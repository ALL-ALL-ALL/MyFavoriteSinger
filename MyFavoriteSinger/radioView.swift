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

class AudioState: ObservableObject {
    @Published var currentlyPlayingID: String?
}

struct radioView: View {
    
    
    
//    init() {
//           // Configurer l'apparence de la barre de navigation
//           let appearance = UINavigationBarAppearance()
//           appearance.configureWithOpaqueBackground()
//           appearance.backgroundColor = UIColor.black // Couleur de fond de la barre
//           appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Couleur du titre en blanc
//           appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Couleur du grand titre en blanc
//
//           UINavigationBar.appearance().standardAppearance = appearance
//           UINavigationBar.appearance().scrollEdgeAppearance = appearance
//       }// pour mettre le bar titlle en blanc
    
    @State private var brands: [Brand] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    
    
   var body: some View {
       
       NavigationStack {
           ZStack{

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
                                   Section() {
                                       ForEach(webRadios) { webRadio in
                                           WebRadioRow(webRadio: webRadio)
                                           Rectangle()
                                               .frame(width: 290, height: 1)
                                               .foregroundColor(.gray)
                                               .padding(.leading,100)
                                               .padding(.top,-2)


                                       } //fin for each
                                   } // fin section
                               }
                           } // fin for each
                       } // fin scroll view
                       .padding(.horizontal,10)
                   } // fin else
               } // fin vstack
               .navigationTitle("Web Radios")
               .navigationBarTitleDisplayMode(.inline)  // titre  centré
               .onAppear(perform: loadBrands)
           } // fin zstack
               
               
               
        } // fin zstack
           
   } // fin body
   
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
   } // fin fun load brand
} // fin struct





// DEBUT MODAL

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
               
               Spacer() // Espace à gauche
           }
           .navigationBarItems(trailing: Button("Fermer") {
               dismiss()
           })
       } // fin navigation view
   } // fin body
} // fin struc



// FIN MODAL



struct WebRadioRow: View {
    let webRadio: WebRadio
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var showModal = false
    @AppStorage("activeRadioID") var activeRadioID: String = "" // @appstorage memoire de la radio qui joue et activeRadioID qui contien id de la radio ou rien

    static var player: AVPlayer?



    


    
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
    } // fin function
    
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
                    .padding(.leading,10)
            }
            .sheet(isPresented: $showModal) {
                ModalView(webRadio: webRadio)
            }
            
            VStack(alignment: .leading) {
                Text(webRadio.title)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            Spacer()
            
            if let streamURL = webRadio.liveStream {
                Button(action: {
                    if isPlaying {
                        Self.player?.pause()
                 
                        activeRadioID = ""

                           }else {
                               
                               
                               Self.player?.pause()
                               Self.player = AVPlayer(url: URL(string: streamURL)!)
                               Self.player?.play()
                               activeRadioID = webRadio.id

                           }
                    
                    isPlaying.toggle()
                }) {
                    
                    Image(systemName: activeRadioID == webRadio.id ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(.trailing,20)
                    
                }
                

               
                }
            

            
            } // fin hstack

        
        
        
        } // fin body
    } // fin struct


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
