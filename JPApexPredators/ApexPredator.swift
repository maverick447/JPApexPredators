//
//  ApexPredator.swift
//  JPApexPredators
//
//  Created by Prashanth Ramachandran on 4/22/25.
//

import SwiftUI
import MapKit

struct ApexPredator: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: APType
    let latitude : Double
    let longitude : Double
    let movies: [String]
    let movieScenes: [MovieScene]
    let link: String
    
    var image: String {
        name.lowercased().replacingOccurrences(of: " ", with: "")
    }
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    struct MovieScene: Decodable, Identifiable {
        let id: Int
        let movie: String
        let sceneDescription: String
    }
}

enum APType: String, Decodable, CaseIterable, Identifiable {
    case all
    case land // land is part of json
    case air  // air is part of json
    case sea  // sea is part of json
    
    var id: APType {
        self
    }
    
    var background: Color {
        switch(self) {
        case .land:
                .brown
        case .air:
                .teal
        case .sea:
                .blue
        case .all:
                .red
        }
    }
    
    var icon:  String {
        switch self {
        case .all:
            "square.stack.3d.up.fill"
        case .land:
            "leaf.fill"
        case .air:
            "wind"
        case .sea:
            "drop.fill"
            
            
        }
    }
 
}
