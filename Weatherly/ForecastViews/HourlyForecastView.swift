//
//  HourlyForecastView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 08.04.2025.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    
    let weatherManager = WeatherManager.shared
    let hourlyForecast: [HourWeather]
    let timeZone: TimeZone?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Hourly Forecast")
                .font(.title)
                .padding(.leading, 10)
            Text("Next 24 hours")
                .font(.caption)
                .padding(.bottom, 10)
                .padding(.leading, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(hourlyForecast, id: \.date) { hour in
                        VStack(spacing: 6) {
                            Text(hour.date.localTime(for: timeZone ?? .current))
                                .font(.caption)
                            
                            Divider()
                            
                            Image(systemName: hour.symbolName)
                                .renderingMode(.original)
                                .symbolVariant(.fill)
                                .font(.system(size: 22))
                                .padding(.bottom, 3)
                            
                            if hour.precipitationChance > 0 {
                                let chance = Int(hour.precipitationChance * 100)
                                Text("\(chance)%")
                                    .foregroundStyle(.cyan)
                                    .bold()
                            }
                            
                            Text(weatherManager.temperatureFormatter
                                .string(from: hour.temperature))
                                .font(.subheadline)
                        }
                        .frame(minWidth: 60)
                    }
                }
                .padding(.horizontal, 15)
            }
            .frame(height: 110)
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.2)))
            
    }
}
