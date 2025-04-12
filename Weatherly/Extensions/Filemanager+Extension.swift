//
//  Filemanager+Extension.swift
//  Weatherly
//
//  Created by Роман Пшеничников on 12.04.2025.
//

import Foundation

extension FileManager {
    static var fileName = "Cities.json"
    static var storageURL = URL.documentsDirectory.appendingPathComponent(fileName, conformingTo: .json)

    func fileExists() -> Bool {
        fileExists(atPath: FileManager.storageURL.path)
    }
    
    func readFile() -> Data? {
        do {
            return try Data(contentsOf: Self.storageURL)
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    func saveFile(content: String) throws {
        do {
            try content.write(to: Self.storageURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving file: \(error)")
            throw error
        }
    }
    
    
    
}

