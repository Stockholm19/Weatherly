//
//  CitiesListView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 08.04.2025.
//

import SwiftUI

struct CitiesListView: View {
    
    @Environment(\.dismiss) private var dismiss
    let currentLocation: City?
    @Binding var selectedCity: City?
    
    
    var body: some View {
        NavigationStack {
            List  {
                Group {
                    if let currentLocation {
                        CityRowView(city: currentLocation)
                            .onTapGesture {
                                selectedCity = currentLocation
                                dismiss()
                            }
                    }
                    ForEach(City.cities.filter { $0.name != currentLocation?.name }) { city in
                        CityRowView(city: city)
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
    }
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
        .environment(LocationManager())
        
}
