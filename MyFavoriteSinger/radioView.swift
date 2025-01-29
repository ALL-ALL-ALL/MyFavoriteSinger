import SwiftUI
import AVKit

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

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    @Published var currentRadio: WebRadio?
    @Published var isPlaying = false
    @Published var currentVolume: Float = 0.5  // Ajout du volume actuel

    static var player: AVPlayer?
    
    func playRadio(_ radio: WebRadio) {
        if let streamURL = radio.liveStream {
            Self.player?.pause()
            Self.player = AVPlayer(url: URL(string: streamURL)!)
            Self.player?.play()
            currentRadio = radio
            isPlaying = true
        }
    }
    // func pour stop
    func stopRadio() {
        Self.player?.pause()
        isPlaying = false
    }
    
    // fonction pour gérer le volume
       func updateVolume(_ value: Float) {
           currentVolume = value
           Self.player?.volume = value
       }
    
    
    
    
    
} // fin class audio manager

struct radioView: View {
    
    @State private var brands: [Brand] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @StateObject private var audioManager = AudioManager.shared
    
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
                        }
                    } else {
                        List {
                            ForEach(brands) { brand in
                                if let webRadios = brand.webRadios, !webRadios.isEmpty {
                                    Section() {
                                        ForEach(webRadios) { webRadio in
                                            WebRadioRow(webRadio: webRadio)

                                        } //fin for each
                                    } // fin section
                                }
                            } // fin for each


                        } // fin list
                        .listStyle(PlainListStyle()) // Supprime le style par défaut de la liste


                    } // fin else
                    
                } // fin vstack
                
                .navigationTitle("Web Radios")
                .navigationBarTitleDisplayMode(.inline)  // titre  centré
                .onAppear(perform: loadBrands)
                .padding(.bottom,50)
            } // fin zstack
        } // fin navigationzstack
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







struct WebRadioRow: View {
    let webRadio: WebRadio
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @StateObject private var audioManager = AudioManager.shared
    
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
            Button(action: {
                
                if webRadio.liveStream != nil {
                    audioManager.playRadio(webRadio)
                }
            }) {
                HStack {
                    Image(getImageName(for: webRadio.id))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 108)
                        .cornerRadius(10)
                        .padding(.leading, 10)
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text(webRadio.title)
                            .foregroundColor(.primary)  // S'adapte dynamique claire/sombre
                            .padding(.leading,15)
                        
                    } // fin vstack
                    
                    Spacer()
                    
                    
                } // fin hstack
            }
        } // fin hstack
        
    } // fin hstack
} // fin body










// DEBUT MODAL

struct ModalView: View {
    
    let webRadio: WebRadio
    let player: AVPlayer?
    
    
    @Environment(\.dismiss) var dismiss
    @State private var volume : Double = 0.5
    @State private var stop = false
    @State private var isDragging = false

    
    
    
    //func vol
    func updateVolume() {
        if let player = AudioManager.player {
            player.volume = Float(volume)
        }
    }
    
    
    
    
    
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
        return imageMapping[webRadioId] ?? ""
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                Image(getImageName(for: webRadio.id))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
                
                
                
                Text(webRadio.title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                
                
                if let description = webRadio.description {
                    Text(description)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,10)
                    
                    
                }
                
                HStack{
                    ZStack{
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.1)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 120, height: 10)
                            .padding()
                            .foregroundColor(.gray.opacity(0.3))
                            .cornerRadius(10)
                            .padding(.trailing,190)
                        
                        Text("Direct")
                            .bold()
                            .font(.title2)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple.opacity(0.1), .blue.opacity(0.6)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        
                            .frame(width: 120, height: 10)
                            .padding()
                            .foregroundColor(.gray.opacity(0.3))
                            .cornerRadius(10)
                            .padding(.leading,190)
                        
                        
                        
                        
                    } //fin zstack
                    
                    
                    
                    
                    
                } // fin hstack
                .padding()
                
                Button {
                    AudioManager.shared.stopRadio()
                } label: {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 45)
                }
                .buttonStyle(.plain)  // supprimer le contour gris
                .padding(.top,40)
                
                
                
                VStack(spacing: 10){
                    HStack(spacing: 15){
                        
                        Image(systemName: "speaker")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)

                        
                        GeometryReader { geometry in
                            
                            
                            
                            ZStack(alignment: .leading) {
                                
                               // Capsule de fond (grise)
                               Capsule()
                                   .fill(Color.gray.opacity(0.3))
                                   .frame(height: 5)
                               
                               // Capsule de volume (colorée)
                               Capsule()
                                    .fill(Color.white)
                                   .frame(width: min(geometry.size.width * volume, geometry.size.width), height: 5)
                           }
                           .gesture(
                               DragGesture(minimumDistance: 0)
                                   .onChanged { value in
                                       // Calculer le nouveau volume basé sur la position du drag
                                       let newVolume = max(0, min(1, value.location.x / geometry.size.width))
                                       self.volume = newVolume
                                   }
                           ) // fin gesture
                       }
                        
                        .padding(.top,61)

                       
                        
                        Image(systemName: "speaker.wave.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 55)
                        


                        
                        
                        
                        
                        
                    } // fin hsatck
                    
                } // fin vstack
                .padding()
                .onAppear {
                    
                    
                    if let player = AudioManager.player {
                        volume = Double(player.volume)
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                } // fin on appear
                
                //           .navigationBarItems(trailing: Button("Fermer") {
                //               dismiss()
                //           })
                
            } // fin vstack
            .padding() // pour limage des radio qui ne doit pas coller en haut
        }// fin navigation view
        
        
    }// fin body
    
    
    
    // FIN MODAL
    
    
    
    
}// fin struc





#Preview {
    radioView()
}
