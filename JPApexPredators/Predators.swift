//
//  Predators.swift
//  JPApexPredators
//
//  Created by Prashanth Ramachandran on 4/22/25.
//

import Foundation

class Predators {
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []
    
    init() {
        decodeApexPredatorData()
    }
    
    func decodeApexPredatorData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                allApexPredators = try decoder.decode([ApexPredator].self, from: data)
                apexPredators = allApexPredators
            } catch {
                print("Error loading JSON file  \(error)")
            }
        }
    }
    
    func search(for searchTerm: String) -> [ApexPredator] {
        if searchTerm.isEmpty {
            return apexPredators
        }
        
        return apexPredators.filter {
            predator in
            predator.name
                .localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    func sort(by alphabetically: Bool)  {
        apexPredators.sort { (predator1, predator2) -> Bool in
            if alphabetically {
                return predator1.name < predator2.name
            } else {
                return predator1.id < predator2.id
            }
        }
    }
    
    func filter(by type: /*ApexPredator.APType*/ APType) {
        if type != .all {
            
            // This is applying the filter and applying to itself
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        }
        // if the type = .all
        else {
            apexPredators = allApexPredators
        }
    }
}
