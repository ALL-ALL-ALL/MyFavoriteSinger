//
//  iTunesModels.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 25/12/2024.
//

import Foundation

struct ITunesResponse: Codable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Codable, Identifiable {
    let id = UUID()
    let trackId: Int
    let artistName: String
    let trackName: String
    let artworkUrl100: String
    let previewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case trackId
        case artistName
        case trackName
        case artworkUrl100
        case previewUrl
    }
}



class TopChartsViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    
    func fetchTopTracks() {
        guard let url = URL(string: "https://itunes.apple.com/fr/search?term=rap+francais+pop+francaise&entity=song&limit=20&sort=recent") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(ITunesResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.tracks = response.results
                }
            } catch {
                print("Erreur de décodage:", error)
            }
        }.resume()
    }
}
