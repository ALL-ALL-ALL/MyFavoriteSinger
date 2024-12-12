//
//  ContentView.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import SwiftUI

struct ContentView: View {
    init() {
           // Configurer l'apparence de la barre de navigation
           let appearance = UINavigationBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = UIColor.black // Couleur de fond de la barre
           appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Couleur du titre en blanc
           appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Couleur du grand titre en blanc

           UINavigationBar.appearance().standardAppearance = appearance
           UINavigationBar.appearance().scrollEdgeAppearance = appearance
       }// pour mettre le bar titlle en blanc
    
   
    var body: some View {

        NavigationStack{

            ZStack{
                Color(.black)

                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.red)
                    .frame(width: 350, height: 400)
                    .padding(.bottom,80)
                
                
                    VStack{
                        Text("Obtenez 3 mois pour le")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                        Text(" prix d'un")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                            .padding(.bottom,380)
                        
                    
                
                    } // fin vstack
                
                HStack{
                    
                    Image(systemName: "applelogo")
                        .foregroundStyle(.white)
                        .font(.system(size: 100))
                        .padding(.bottom,90)

                    Text("Music")
                        .foregroundStyle(.white)
                        .font(.system(size: 70))
                        .padding(.bottom,90)

                    
                } // fin hstack
                
                Text("Essayer maintenant" )
                    .foregroundStyle(.white)
                    .padding(.top,210)

                Text("3 mois pour 16,99e,puis 16,99e/mois.")
                    .foregroundStyle(.white)
                    .padding(.top,260)


            } // fin zstack
            
                .navigationTitle("ACCUEIL")
                .ignoresSafeArea()
        } // fin NavigationView
        
        
        
        
        

        
    } // fin body
} // fin struct

#Preview {
    ContentView()
}
