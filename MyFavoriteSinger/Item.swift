//
//  Item.swift
//  MyFavoriteSinger
//
//  Created by  Ixart on 07/07/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var NameArtist : String
    var NameSong : String
    
    init(NameArtist: String, NameSong:String) {
        self.NameArtist = NameArtist
        self.NameSong = NameSong
    }
}


struct RadioStation: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let url: String
    let country: String
    let favicon: String? // URL vers l'icône de la station
}


