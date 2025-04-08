//
//  CityRowView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 08.04.2025.
//

import SwiftUI
import WeatherKit

struct CityRowView: View {
    let weatherManager = WeatherManager.shared
    @Environment(LocationManager.self) var locationManager
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    @State private var timeZone: TimeZone? = .current
    let city: City
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if let currentWeather {
                    VStack(alignment: .leading) {
                        HStack{
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.title)
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                Text(currentWeather.date.localDate(for: timeZone ?? .current))
                                    .bold()
                            }
                            Spacer()
                            let temp =
                                weatherManager.temperatureFormatter.string(from:
                                currentWeather.temperature)
                            Text(temp)
                                .font(.system(size: 60, weight: .thin, design: .rounded))
                                .fixedSize(horizontal: true, vertical: true)
                            Text(currentWeather.condition.description)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .background{
            if let condition = currentWeather?.condition {
                BackgroundView(condition: condition)
                    .blur(radius: 5)
                    .colorMultiply(.white.opacity(0.8))
            }
        }
        .task(id: city) {
            await fetchWeather(for: city)
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
    CityRowView(city: City.mockCurrent)
        .environment(LocationManager())
}
