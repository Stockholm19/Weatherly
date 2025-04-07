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
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    @State private var showCitiesList = false
    @State private var timeZone: TimeZone? = .current
    
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
                        Text(currentWeather.date.localDate(for: timeZone ?? .current))
                        Text(currentWeather.date.localTime(for: timeZone ?? .current))
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
                        Spacer()
                        AttributionView()
                            .tint(.white)
                    }
                }
            }
        }
        .padding()
        .background{
            if selectedCity != nil,
               let condition = currentWeather?.condition {
                BackgroundView(condition: condition)
                    .ignoresSafeArea()
            }
        }
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom) {
            Button {
                showCitiesList.toggle()
            } label: {
                Image(systemName: "list.star")
                    .padding()
                    .background(Color(.darkGray))
                    .clipShape(Circle())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
            }
            .fullScreenCover(isPresented: $showCitiesList) {
                NavigationStack {
                    CitiesListView(currentCity: selectedCity, selectedCity: $selectedCity)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Done") {
                                    showCitiesList = false
                                }
                            }
                        }
                }
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                selectedCity = locationManager.currentCity
                if let selectedCity {
                    Task {
                        await fetchWeather(for: selectedCity)
                    }
                }
            }
        }
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
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timeZone = await locationManager.getTimezone(for: city.clLocation)
            
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
}
