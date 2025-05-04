//
//  PredatorDetail.swift
//  JPApexPredators
//
//  Created by Prashanth Ramachandran on 4/24/25.
//

import SwiftUI
import MapKit


struct DinosaurDetailView: View {
    let predator: ApexPredator
    
    var body: some View {
        VStack {
            //Text("Details for \(dinosaurName)")
            //    .font(.largeTitle)
            // Add more detailed information and UI elements here
            //Text("This is where you'd put more info about the T-Rex!")
            Image(predator.image)
                .resizable()
                .scaledToFit()
            Button("Dismiss") {
                // Access the presentationMode environment variable to dismiss
                // In iOS 16 and later, the environment variable is deprecated for this purpose.
                // Instead, the binding to isPresented in the .sheet modifier automatically handles dismissal.
                // You would typically just set isPresentingDinosaurDetails back to false
                // in the parent view if you needed more complex dismissal logic from here.
                isPresentingDinosaurDetails = false
            }
        }
        .padding()
    }
}

struct PredatorDetail: View {
    let predator: ApexPredator
    
    @State var position: MapCameraPosition
    @State  var isPresentingDinosaurDetails = false
    @Namespace var namespace
    
    var body: some View {
            GeometryReader { geo in
            ScrollView {
                ZStack(alignment: .bottomTrailing) {
                    // Background image
                    
                    Image(predator.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        // Gradient View
                        .overlay {
                            LinearGradient(stops:[
                                Gradient.Stop(color: .clear, location: 0.8),
//                                Gradient.Stop(color: .red, location: 0.33),
//                                Gradient.Stop(color: .blue, location: 0.66),
                                Gradient.Stop(color: .black, location: 1)],
                                           startPoint: .top, endPoint: .bottom)
                        }
                   
                    Button {
                        isPresentingDinosaurDetails = true
                    } label: {
                        Image(predator.image) // Replace with your actual image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width/1.5, height: geo.size.height/3.7)
                            .scaleEffect(x: -1)
                            .shadow(color: .black, radius: 7)
                            .offset(y: 20)
                        // Add other image modifiers as needed (e.g., frame)
                    }
//                    // Dino image
//                    Image(predator.image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: geo.size.width/1.5, height: geo.size.height/3.7)
//                    // Border below just demonstarates how big it is
////                        .border(.blue, width: 7)
//                    // flip it around
////                        .scaleEffect(x: 1.25, y: 1.25)
////                        .scaleEffect(2)
//                        .scaleEffect(x: -1)
//                    // To set it - bottom right it's done at the Zstack level
//                        .shadow(color: .black, radius: 7)
//                    // The head of dino is interfering with the physical display
//                        .offset(y: 20)
////                        .offset(x: 20, y: 20)
                }
                .sheet(isPresented: $isPresentingDinosaurDetails) {
                    
                    DinosaurDetailView(predator: predator)
                }
                // The below two statements are there to just show the width and height of geo
//                Text("Width: \(geo.size.width)")
//                Text("Height: \(geo.size.height)")
                VStack(alignment: .leading) {
                    // Dino name
                    Text(predator.name)
                        .font(.largeTitle)
                       
//                    Text(predator.name + predator.name)
                    
                    // Current location (map view)
                    // map map map
                    // Can be done using Zstack or an overlay
                    NavigationLink {
//                        Image(predator.image)
//                            .resizable()
//                            .scaledToFit()
                        PredatorMap(position: .camera(MapCamera(
                            centerCoordinate: predator.location,
                            distance: 1000,
                            heading: 250,
                            pitch: 80)))
                        .navigationTransition(.zoom(sourceID: 1, in: namespace))
                        
                    } label: {
                        Map(position: $position) {
                            Annotation(predator.name, coordinate: predator.location) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .symbolEffect(.pulse)
                            }
                            .annotationTitles(.hidden)
                        }
                    }
                    .frame(height: 125)
                    .clipShape(.rect(cornerRadius: 15))
                    // > image that can be correct to indicate that there is fullscreen
                    .overlay(alignment: .trailing) {
                        Image(systemName: "greaterthan")
                            .imageScale(.large)
                            .font(.title3)
                            .padding(.trailing, 5)
                    }
                    
                    // heading within map
                    .overlay(alignment: .topLeading) {
                        Text("Current Location")
                            .padding([.leading, .bottom], 5)
                            .padding(.trailing, 8)
                            .background(.black.opacity(0.33))
                            .clipShape(.rect(bottomTrailingRadius: 15))
                    }
                    .clipShape(.rect(cornerRadius: 15))
                    .matchedTransitionSource(id: 1, in: namespace)
                    
                    // Appears in the following movies
                    Text("Appears In:")
                        .font(.title3)
                        .padding(.top)
                    
                    ForEach(predator.movies, id: \.self) { movie in
                        Text("•" + movie)
                            .font(.subheadline)
                    }
                    
                    // Movie moments in each movie
                    Text("Movie Moments")
                        .font(.title)
                        .padding(.top, 15)
                    
                    ForEach(predator.movieScenes) { moviescene in
                        Text(moviescene.movie)
                            .font(.title2)
                            .padding(.vertical, 1)
                        
                        Text(moviescene.sceneDescription)
                            .padding(.bottom, 15)
                            
                    }
                    
                    // link to the webpage
                    Text("Read More:")
                        .font(.caption)
                    
                    Link(predator.link, destination:
                            URL(string: predator.link)!)
                    .font(.caption)
                    .foregroundStyle(.blue)
                    
                    
                } // VStack
//                .border(.blue)
                .padding()
                .padding(.bottom)
                // For alignment of the name of dinosaur
                .frame(width: geo.size.width, alignment: .leading)
            } // ScrollView End
            
        } // GeometryReader
        .ignoresSafeArea()
        .toolbarBackground(.automatic)
        
    }
}

#Preview {
    //note that this is made only to preview and show items in mapkit
    NavigationStack {
        let predator = Predators().apexPredators[2]
        PredatorDetail(predator: predator, position: .camera(
            MapCamera(centerCoordinate: predator.location,
                      distance: /* from 30000 feet above the location*/ 30000)))
        .preferredColorScheme(.dark)
    }
}
