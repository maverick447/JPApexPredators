//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Prashanth Ramachandran on 4/22/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let predators = Predators()
    @State var searchText = ""
    @State var alphabetical: Bool = false
    @State var currentFilterSelection = APType.all
    
    var filteredDinos: [ApexPredator] {
        predators.filter(by: currentFilterSelection)
        predators.sort(by: alphabetical)
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List(filteredDinos) { predator in
                NavigationLink {
                    PredatorDetail(predator: predator, position: .camera(
                        MapCamera(centerCoordinate: predator.location,
                                  distance: /* from 30000 feet above the location*/ 30000)))
                    
                } label: {
                    //Text(predator.name)
                    HStack {
                        // Dinosaur image
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .white, radius: 1)
                        
                        VStack(alignment: .leading) {
                            // Name
                            Text(predator.name)
                                .fontWeight(.bold)
                            
                            // Type
                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(predator.type
                                    .background)
                                .clipShape(.capsule)
                        }
                    } // HStack
                } // End of NavgationLink
            } // list
            .navigationTitle(Text("Apex Predators"))
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(Animation.linear, value: searchText)
            // Toolbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            alphabetical.toggle()
                        }
                    } label: {
                        // ternary operator
                        Image(systemName: alphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: alphabetical)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $currentFilterSelection.animation()){
                            ForEach(APType.allCases) {
                                type in
                                Label(type.rawValue.capitalized,
                                      systemImage:type.icon)
                            }
                        }
                    } label: {
                        // ternary operator
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
