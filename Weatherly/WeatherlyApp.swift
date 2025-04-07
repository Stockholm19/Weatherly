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
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
            } else {
                LocationDeniedView()
            }
            
        }
        .environment(locationManager)
    }
}
