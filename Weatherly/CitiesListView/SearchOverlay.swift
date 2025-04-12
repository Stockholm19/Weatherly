//
//  SearchOverlay.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 12.04.2025.
//

import SwiftUI
import MapKit

struct SearchOverlay: View {
    
    @Binding var isSearching: Bool
    @Environment(DataStore.self) private var store
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    @StateObject private var searchService = SearchService(completer:
        MKLocalSearchCompleter())
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .focused($isFocused)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                    Button(action: {
                        withAnimation {
                            isSearching = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                List {
                    ForEach(searchService.cities) { city in
                        Button {
                            if !store.cities.contains(where: {
                                $0.coordinate.latitude == city.coordinate.latitude &&
                                $0.coordinate.longitude == city.coordinate.longitude
                            }) {
                                store.cities.insert(city, at: 0)
                            }
                            isSearching = false
                        } label: {
                            Text(city.name)
                                .font(.headline)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .onChange(of: searchText) {
            searchService.update(queryFragment: searchText)
        }
        .onChange(of: searchService.cities) {
            print("Обновились города: \(searchService.cities.map(\.name))")
        }
        .onAppear {
            searchService.cities = []
            isFocused = true
            searchText = ""
        }
    }
}

#Preview {
    SearchOverlay(isSearching: .constant(true))
        .environment(DataStore(forPreviews: true))
        
}
