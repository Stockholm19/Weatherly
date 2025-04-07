//
//  LocationManager.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 07.04.2025.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager()
    var userLocation: CLLocation?
    var currentCity: City?
    var isAuthorized = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
            isAuthorized = true
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        if let location = userLocation {
            Task {
                let cityName = await getLocation(for: location)
                currentCity = City(name: cityName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    func getLocation(for location: CLLocation) async -> String {
        let name = try? await CLGeocoder().reverseGeocodeLocation(location).first?.locality
        return name ?? ""
    }
    
    func getTimezone(for location: CLLocation) async -> TimeZone? {
        let timeZone = try? await CLGeocoder().reverseGeocodeLocation(location).first?.timeZone
        return timeZone ?? .current
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                isAuthorized = true
                manager.startUpdatingLocation()
            case .denied, .restricted:
                isAuthorized = false
                manager.stopUpdatingLocation()
            case .notDetermined:
                isAuthorized = false
                manager.requestWhenInUseAuthorization()
            default:
                startLocationServices()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
