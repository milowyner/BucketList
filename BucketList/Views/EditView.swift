//
//  EditView.swift
//  BucketList
//
//  Created by Milo Wyner on 9/6/21.
//

import SwiftUI
import MapKit

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    let onDisappear: (() -> Void)
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $placemark.wrappedTitle)
                    TextField("Description", text: $placemark.wrappedSubtitle)
                }
                
                Section(header: Text("Nearby...")) {
                    if loadingState == .loaded {
                        List(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    } else if loadingState == .loading {
                        Text("Loading...")
                    } else {
                        Text("Please try again later.")
                    }
                }
            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: fetchNearbyPlaces)
            .onDisappear {
                // give the placemark a title if empty, because MapKit doesn't show callouts for pins that don't have titles
                if placemark.wrappedTitle.isEmpty {
                    placemark.title = "Untitled Place"
                }
                onDisappear()
            }
        }
    }
    
    func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            loadingState = .failed
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let items = try JSONDecoder().decode(Result.self, from: data)
                    pages = Array(items.query.pages.values).sorted()
                    loadingState = .loaded
                    return
                } catch {
                    print("Error decoding data from Wikipedia:", error.localizedDescription)
                }
            } else if let error = error {
                print("Error fetching data from Wikipedia:", error.localizedDescription)
            }
            
            loadingState = .failed
        }.resume()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placemark: MKPointAnnotation.example, onDisappear: {})
    }
}
