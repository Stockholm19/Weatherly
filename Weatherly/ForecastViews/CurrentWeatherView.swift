//
//  CurrentWeatherView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 08.04.2025.
//

import SwiftUI
import WeatherKit

struct CurrentWeatherView: View {
    
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let highTemperature: String?
    let lowTemperature: String?
    let timeZone: TimeZone?

    
    var body: some View {
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
        if let highTemperature, let lowTemperature {
            Text("H: \(highTemperature) L: \(lowTemperature)")
                . bold()
        }
        Text(currentWeather.condition.description)
            .font(.title3)
    }
}
