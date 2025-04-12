//
//  WeatherlyApp.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 07.04.2025.
//

import SwiftUI

@main
struct WeatherlyApp: App {
    
    @State private var locationManager = LocationManager()
    @State private var store = DataStore()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
                    .onAppear {
                        print(URL.documentsDirectory.path())
                    }
            } else {
                LocationDeniedView()
            }
            
        }
        .environment(locationManager)
        .environment(store)
    }
}
