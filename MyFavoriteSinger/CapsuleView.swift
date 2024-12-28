//
//  CapsuleView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 27/12/2024.
//

import SwiftUI
import AVKit

struct CapsuleView: View {
    @AppStorage("activeRadioID") var activeRadioID: String = ""
    
    @State private var showModal = false
    @State private var isPlaying = false
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
        return imageMapping[webRadioId] ?? "1"
    } // fin function
    

    var body: some View {
        
        ZStack{
            
            
            Button {
                showModal = true
            } label: {
                Rectangle()
                    .fill(.gray.opacity(1.2))
                    .cornerRadius(20)
                    .frame(width: 380, height: 80)
                
            }
            .sheet(isPresented: $showModal) {
                ModalView(webRadio: webRadio, player: Self.player)
            
            }

    
            
            HStack(spacing: 20){
                Spacer()
                
                
                Button {
                    isPlaying.toggle()
                    
                } label: {
                    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                    
                }

                
                
                Button {
                    //
                } label: {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                    
                }
                
                
            } // fin hstack
            .padding()
            
            
            
            
            
            HStack{
                Image(getImageName(for: webRadio.id))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                    .cornerRadius(12)
                    .padding(.trailing,300)
            } // fin hstack
            
            
//            HStack{
//                Text("France Inter")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding(.trailing,90)
//
//
//            } // fin hstack
                
               
                Text(webRadio.title)
                    .font(.title2)
                    .foregroundColor(.white)
                
            
        } // fin zstack
        
                
                
                

                
       
        
        
        
    } // fin body
} // fin strutc


#Preview {
    CapsuleView(webRadio:WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}





//
//Button {
//    
//    if isPlaying {
//        Self.player?.pause()
//        activeRadioID = ""
//    } else {
//        if let streamURL = webRadio.liveStream {
//            Self.player?.pause()
//            Self.player = AVPlayer(url: URL(string: streamURL)!)
//            Self.player?.play()
//            activeRadioID = webRadio.id
//        }
//    }
//    isPlaying.toggle()
//} label: {
//    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
//    
//           .foregroundColor(.white)
//           .font(.system(size: 30))
//    
//    
//    }
