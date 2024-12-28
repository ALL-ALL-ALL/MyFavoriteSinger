//
//  CapsuleView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 27/12/2024.
//

import SwiftUI
import AVKit

struct CapsuleView: View {
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
    
    
    
    
    let webRadio: WebRadio

    var body: some View {
        
        
        VStack {
            
            HStack {
                ZStack{
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(width: 410, height: 70)
                    
                    Image(getImageName(for: webRadio.id))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 60)
                        .cornerRadius(12)
                        .padding(.trailing,330)
                    
                    
                    
                    
                    Text("James Blunt")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.leading,-120)
                    
                    Text(webRadio.title)
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.trailing,190)

                    
                    
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 30))
                            .padding(.leading,220)
                        
                    }
                    
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 30))
                            .padding(.leading,330)

                        
                    }

                                
                    }// fin zstack
                
               
                
               
                
                
                
                    
                
                
            } // fin hstack
        } // fin vstack
       
        
        
        
    } // fin body
} // fin strutc


#Preview {
    CapsuleView(webRadio:WebRadio(id: "", title: "", description: "", liveStream: "", playerUrl: "", image: ""))
}
