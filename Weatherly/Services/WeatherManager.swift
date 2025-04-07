//
//  WeatherManager.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 07.04.2025.
//



import Foundation
import WeatherKit
import CoreLocation

class WeatherManager {
    static let shared = WeatherManager()
    static let service = WeatherService.shared
    
    var temperatureFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
        
    
    func currentWeather(for location: CLLocation) async -> CurrentWeather? {
        let currentWeather = await Task.detached(priority: .userInitiated) {
            let forecast = try? await WeatherManager.service.weather(
                for: location,
                including: .current
            )
            return forecast
        }.value
        return currentWeather
    }
    
    func weatherAtribution() async -> WeatherAttribution? {
        let attribution = await Task(priority: .userInitiated) {
            return try? await WeatherManager.service.attribution
        }.value
        return attribution
    }
}
