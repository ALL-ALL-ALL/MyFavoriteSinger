//
//  SpotifyArtistModel.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 01/01/2025.
//

import Foundation
import AVKit


struct SpotifyArtist: Codable, Identifiable {
    let id: String
    let name: String
    let genres: [String]
    let popularity: Int
    let followers: Followers
    let images: [SpotifyImage]
    let externalUrls: ExternalUrls
    
    struct Followers: Codable {
        let total: Int
    }
    
    struct SpotifyImage: Codable {
        let url: String
        let height: Int
        let width: Int
    }
    
    struct ExternalUrls: Codable {
        let spotify: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, genres, popularity, followers
        case images, externalUrls = "external_urls"
    }
}


struct TokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct ArtistsResponse: Codable {
    let artists: [SpotifyArtist]
}

struct TopTracksResponse: Codable {
    let tracks: [Track]
    
    struct Track: Codable {
        let previewUrl: String?
    }
}





struct SpotifyService {
    static func getSpotifyToken(completion: @escaping (String?) -> Void) {
        let clientId = "625ec108823c4bf38365222cc8bd78b5"
        let clientSecret = "edfefc67465f49d7887cc3ddf52e26a3"
        
        let credentials = "\(clientId):\(clientSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
        
        let urlString = "https://accounts.spotify.com/api/token"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = "grant_type=client_credentials"
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                completion(tokenResponse.accessToken)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    
    
    
    
    
    static func fetchArtists(token: String, completion: @escaping ([SpotifyArtist]) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/artists?ids=2CIMQHirSU0MQqyYHq0eOx,57dN52uHvrHOxijzpIgu3E,1vCWHaC5f2uS3yhpwWbIA6,06HL4z0CvFAxyc27GXpf02,3TVXtAsR1Inumwj472S9r4,6eUKZXaKkcviH0Ku9w2n3V,66CXWjxzNUsdJxJ2JdwvnR,1Xyo4u8uXC1ZmMpatF05PJ,6M2wZ9GZgrQXHCFfjv46we,0C8ZW7ezQVs4URX5aX7Kqx,3WrFJ7ztbogyGnTHbHJFl2,246dkjvS1zLTtiykXe5h60,6qqNVTkY8uBg9cP3Jd7DAH,0du5cEVh5yTK9QJze8zA0C,6KImCVD70vtIoJWnq6nGn3,1uNFoZAHBGtllmzznpCI3s,64KEffDW9EtZ1y2vBYgq8T,3WGpXCj9YhhfX11TToZcXP,5K4W6rqBFWDnAN6FQUkS6x,4q3ewBCX7sLwd24euuV69X")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let artistsResponse = try JSONDecoder().decode(ArtistsResponse.self, from: data)
                completion(artistsResponse.artists)
            } catch {
                print("Erreur de décodage : \(error)")
                completion([])
            }
        }.resume()
    }
    
    static func fetchTopTrack(artistId: String, token: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://api.spotify.com/v1/artists/\(artistId)/top-tracks?market=FR"
        var request = URLRequest(url: URL(string: urlString)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let topTracksResponse = try JSONDecoder().decode(TopTracksResponse.self, from: data)
                let previewUrl = topTracksResponse.tracks.first?.previewUrl
                completion(previewUrl)
            } catch {
                print("Erreur de récupération du top track : \(error)")
                completion(nil)
            }
        }.resume()
    }
}




class SpotifyViewModel: ObservableObject {
    @Published var artists: [SpotifyArtist] = []
    
    func fetchTopArtists() {
        SpotifyService.getSpotifyToken { token in
            guard let token = token else { return }
            SpotifyService.fetchArtists(token: token) { artists in
                DispatchQueue.main.async {
                    self.artists = artists
                }
            }
        }
    }
}
