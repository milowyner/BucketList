//
//  AddPlacesView.swift
//  BucketList
//
//  Created by Milo Wyner on 9/8/21.
//

import SwiftUI
import MapKit

struct AddPlacesView: View {
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingEditScreen = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.coordinate = centerCoordinate
                        locations.append(newLocation)
                        
                        selectedPlace = newLocation
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                    }
                }
                .padding(.trailing)
            }
        }
        .sheet(item: $selectedPlace) { place in
            EditView(placemark: place, onDisappear: saveData)
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try Data(contentsOf: url)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Error loading data:", error.localizedDescription)
        }
    }
    
    func saveData() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(locations)
            try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Error saving data:", error.localizedDescription)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct AddPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlacesView()
    }
}
