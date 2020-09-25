//
//  RestaurantsStore.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/8/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import Foundation

struct RestaurantsStore {
    let restaurantsData: [Restaurant]
    var pictures = [String]()
    
    struct FoodItem: Identifiable, Codable, Hashable {
        let name: String
        let price: Double
        let size: Int
        let imageURL: String?
        let id = UUID()
        
        
    }
    
    struct Restaurant: Identifiable, Codable {
        let id = UUID()
        let name: String
        let menu: [RestaurantsStore.FoodItem]
    }
    
    init() {
        self.restaurantsData = RestaurantsStore.load("test.json")
    }
    
    // Credit to Apple Inc, retrieved from Apple's SwiftUI official tutorial
    // at https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
