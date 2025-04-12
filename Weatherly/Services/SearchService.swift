//
//  SearchService.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 12.04.2025.
//

import MapKit

class SearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var cities: [City] = []
    
    private let completer: MKLocalSearchCompleter
    private var searchTask: Task<Void, Never>?

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }
    
    func update(queryFragment: String) {
    let trimmed = queryFragment.trimmingCharacters(in: .whitespaces)
    guard trimmed.count >= 2 else {
        return
    }
    
    completer.resultTypes = [.address]
    completer.queryFragment = trimmed
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchTask?.cancel()

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)

            await MainActor.run {
                self.cities = []
            }

            for completion in completer.results.prefix(5) {
                let searchRequest = MKLocalSearch.Request(completion: completion)
                let search = MKLocalSearch(request: searchRequest)

                do {
                    let response = try await search.start()
                    if let mapItem = response.mapItems.first {
                        let city = City(
                            name: completion.title,
                            latitude: mapItem.placemark.coordinate.latitude,
                            longitude: mapItem.placemark.coordinate.longitude
                        )
                        await MainActor.run {
                            self.cities.append(city)
                        }
                    }
                } catch {
                    print("Search error:", error.localizedDescription)
                }
            }
        }
    }
}
