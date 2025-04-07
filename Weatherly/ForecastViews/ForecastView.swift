//
//  ContentView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 07.04.2025.
//

// 55.855004, 37.475685

import SwiftUI
import WeatherKit
import CoreLocation

struct ForecastView: View {
    
    @Environment(LocationManager.self) private var locationManager
    @State private var selectedCity: City?
    
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if let selectedCity {
                if isLoading {
                    ProgressView()
                    Text("Fetching Weather...")
                } else {
                    Text(selectedCity.name)
                        .font(.title)
                    if let currentWeather {
                        Text(Date.now.formatted (date: .abbreviated, time: .omitted))
                        Text(Date.now.formatted(date: .omitted, time: .shortened))
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.secondary.opacity(0.2))
                                .frame(width: 100, height: 100)

                            Image(systemName: currentWeather.symbolName)
                                .renderingMode(.original)
                                .symbolVariant(.fill)
                                .font(.system(size: 60, weight: .bold))
                        }
                        .padding()
                        let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                        Text(temp)
                            .font(.title2)
                        Text(currentWeather.condition.description)
                            .font(.title3)
                        AttributionView()
                    }
                }
            }
        }
        .padding()
        .task(id: locationManager.userLocation) {
            if let currentLocation = locationManager.userLocation,
               selectedCity == nil {
                selectedCity = City(
                    name: "Current Location",
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude
                )
            }
        }
        
        .task(id: selectedCity) {
            if let selectedCity {
                await fetchWeather(for: selectedCity)
            }
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: CLLocation(latitude: city.latitude, longitude: city.longitude))
            
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
}
