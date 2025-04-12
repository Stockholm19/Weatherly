//
//  CitiesListView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 08.04.2025.
//

import SwiftUI

struct CitiesListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(DataStore.self) private var store
    let currentLocation: City?
    @Binding var selectedCity: City?
    @State private var isSearching = false
    @FocusState private var isFocused: Bool
    

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: .constant(""))
                            .focused($isFocused)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: isFocused) {
                                if isFocused {
                                    withAnimation {
                                        isSearching = true
                                    }
                                }
                            }
                    }
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isSearching.toggle()
                        }
                    }
                    
                    List  {
                        Group {
                            if let currentLocation {
                                CityRowView(city: currentLocation)
                                    .onTapGesture {
                                        selectedCity = currentLocation
                                        dismiss()
                                    }
                            }
                            ForEach(store.cities) { city in
                                CityRowView(city: city)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            if let index = store.cities.firstIndex(where: { $0.id == city.id }) {
                                                store.cities.remove(at: index)
                                                store.saveCities()
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .onTapGesture {
                                        selectedCity = city
                                        dismiss()
                                    }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .listRowInsets(.init(top: 0, leading: 20, bottom: 5, trailing: 10))
                    }
                    .listStyle(.plain)
                    .navigationTitle("My Cities")
                    .navigationBarTitleDisplayMode(.inline)
                }
                if isSearching {
                    SearchOverlay(isSearching: $isSearching)
                        .zIndex(1.0)
                }
            }
        }
    }
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
        .environment(LocationManager())
        .environment(DataStore(forPreviews: true))
        
}
