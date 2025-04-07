//
//  CitiesListView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 08.04.2025.
//

import SwiftUI

struct CitiesListView: View {
    
    @Environment(\.dismiss) private var dismiss
    let currentCity: City?
    @Binding var selectedCity: City?
    
    
    var body: some View {
        NavigationStack {
            List {
                if let currentCity {
                    Text(currentCity.name)
                        .onTapGesture {
                            selectedCity = currentCity
                            dismiss()
                        }
                }
                ForEach(City.cities.filter { $0.name != currentCity?.name }) { city in
                    Text(city.name)
                        .onTapGesture {
                            selectedCity = city
                            dismiss()
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("My Cities")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CitiesListView(currentCity: City.mockCurrent, selectedCity: .constant(nil))
}
