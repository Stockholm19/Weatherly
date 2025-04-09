//
//  DailyForecastView.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 09.04.2025.
//

import SwiftUI
import WeatherKit

struct DailyForecastView: View {
    
    let weatherManager = WeatherManager.shared
    let dailyForecast: Forecast<DayWeather>
    @State private var barWidth: Double = 0
    let timeZone: TimeZone?
    
    var body: some View {
        Text("Ten day Forecast")
            .font(.title)
        VStack {
            let dailyData = dailyForecast.forecast
            let maxDayTemp = dailyData.map { $0.highTemperature.value }.max() ?? 0
            let minDayTemp = dailyData.map { $0.lowTemperature.value }.min() ?? 0
            let tempRange = maxDayTemp - minDayTemp
            
            ForEach(dailyData, id: \.date) { day in
                LabeledContent {
                    HStack(spacing: 0.0) {
                        HStack(spacing: 4) {
                            Image(systemName: day.symbolName)
                                .renderingMode(.original)
                                .symbolVariant(.fill)
                                .font(.system(size: 20))
                            let chance = Int(day.precipitationChance * 100)
                            Text(day.precipitationChance > 0 ? "\(chance)%" : "")
                                .foregroundStyle(.cyan)
                                .bold()
                                .font(.system(size: 15))
                        }
                        .frame(width: 60, alignment: .leading)
                        .padding(.trailing, 10)
                        
                        Text(weatherManager.temperatureFormatter.string(from: day.lowTemperature))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.trailing, 5)
                            .frame(width: 50)
                            
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.secondary.opacity(0.1))
                            .frame(height: 5)
                            .readSize { size in
                                barWidth = size.width
                            }
                            .overlay {
                                let degreeFactor = barWidth / tempRange
                                let dayRangeWidth = (day.highTemperature.value - day.lowTemperature.value) * degreeFactor
                                let xOffset = (day.lowTemperature.value - minDayTemp) * degreeFactor
                                HStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                colors: [.green, .orange],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: dayRangeWidth, height: 5)
                                    Spacer()
                                }
                                .offset(x: xOffset)
                            }
                        
                        Text(weatherManager.temperatureFormatter.string(from: day.highTemperature))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.trailing, 5)
                            .frame(width: 50)
                    }
                    .frame(height: 40)
                } label: {
                    Text(day.date.formatted(.dateTime.weekday()))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: 60)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.2)))
      
    }
}
