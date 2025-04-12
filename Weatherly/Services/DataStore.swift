//
//  DateStore.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 12.04.2025.
//

import Foundation

@Observable
class DataStore  {
    var forPreviews: Bool
    var cities: [City] = []
    
    init(forPreviews: Bool = false) {
        self.forPreviews = forPreviews
        loadCities()
    }
    
    func loadCities() {
        if forPreviews {
            cities = City.cities
        } else {
            let fileManager = FileManager()
            if fileManager.fileExists() {
                if let data = fileManager.readFile() {
                    do {
                        let decoder = JSONDecoder()
                        cities = try decoder.decode([City].self, from: data)
                    } catch {
                        print("Error decoding file: \(error)")
                    }
                }
            }
        }
    }
    
    func saveCities() {
        if !forPreviews {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(cities)
                let jsonString = String(decoding: data, as: UTF8.self)
                try FileManager().saveFile(content: jsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
