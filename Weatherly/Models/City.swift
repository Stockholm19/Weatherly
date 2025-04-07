//
//  City.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 07.04.2025.
//

import Foundation
import CoreLocation

struct City: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    static var cities: [City] {
        [
            .init(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
            .init(name: "Saint Petersburg", latitude: 59.9343, longitude: 30.3351),
            .init(name: "Novosibirsk", latitude: 55.0084, longitude: 82.0155),
            .init(name: "Yekaterinburg", latitude: 56.8389, longitude: 60.6057),
            .init(name: "Nizhny Novgorod", latitude: 56.2965, longitude: 43.9361)
        ]
    }
    
    static var mockCurrent: City {
        .init(name: "Moscow", latitude: 55.7558, longitude: 37.6173)
    }
}
