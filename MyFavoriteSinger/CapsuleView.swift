//
//  CapsuleView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 27/12/2024.
//

import SwiftUI
import AVKit

struct CapsuleView: View {
    
    @State private var isPlaying = false
    @StateObject private var musicManager = MusicPlayerManager.shared
    @StateObject private var audioManager = AudioManager.shared
    @State private var showModal = false
    @State private var playingRadio: WebRadio?
    @AppStorage("activeRadioID") var activeRadioID: String = "" // @appstorage memoire de la radio qui joue et activeRadioID qui contien id de la radio ou rien
    
    static var player: AVPlayer?
    let webRadio: WebRadio
    
    
    
    
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
        return imageMapping[webRadioId] ?? ""
    } // fin function
    
    
    var body: some View {
        VStack{
            ZStack{
                
                
                Button {
                    if audioManager.isPlaying{
                        showModal = true
                    }
                } label: {
                    Rectangle()
                        .fill(Color(UIColor.secondarySystemBackground))
                    
//                        .fill(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))

                    
                        .cornerRadius(15)
                        .frame(width: 380, height: 50)
                    
                }
                .buttonStyle(.plain)  // supprimer le contour gris qui est visible sur le portable

                
                .sheet(isPresented: $showModal) {
                    ModalView(webRadio: webRadio, player: Self.player)
                }
                
                
                
                HStack{
                    Spacer()
                    
                    
                    Button {
                        isPlaying.toggle()
                        if audioManager.isPlaying {
                            audioManager.stopRadio()
                        } else if webRadio.liveStream != nil {
                            audioManager.playRadio(webRadio)
                        }
                        
                    } label: {
                        Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .padding(.trailing,30)
                        
                    }
                    .buttonStyle(.plain)  //  supprimer le contour gris

                    
                    
                    
                } // fin hstack
                .padding()
                
                
                
                
                
                HStack {
                    // Afficher l'image de la radio uniquement si AUCUNE musique locale n'est en cours
                    if musicManager.currentSong == nil {
                        Image(getImageName(for: webRadio.id))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 38)
                            .cornerRadius(12)
                            .padding(.trailing, 300)
                    }
                }
                
                
                //                Text(musicManager.currentSong?.title ?? "Aucune sélection")
                // tester le code juste en haut sans le code d'en bas text(musicManager.currentSong?.title ?? .........
                
                Text(musicManager.currentSong?.title ?? audioManager.currentRadio?.title ?? "Aucune sélection")


                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.primary)  // S'adapte dynamique claire/sombre
                    .frame(width: 200, height: 60, alignment: .leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.trailing,20)
                
                
                
                
                
                
                
                
            } // fin zstack
            
            
            
        } // fin vstack
        
        
        
        
        
        
        
        
        
        
        
    } // fin body
} // fin strut


#Preview {
    CapsuleView(webRadio:WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}





