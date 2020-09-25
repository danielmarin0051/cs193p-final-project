//
//  ContentView.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/7/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

struct FoodItem: Identifiable {
    let name: String
    let price: Double
    let size: Int
    let imageURL: String?
    let id = UUID()
}

let foodItems: [FoodItem] = [
    FoodItem(name: "Chocolate Cake", price: 10.0, size: 1000, imageURL: nil),
    FoodItem(name: "Vanilla Ice cream", price: 3.0, size: 200, imageURL: nil),
    FoodItem(name: "Oreo Cookie", price: 2.0, size: 50, imageURL: nil),
    FoodItem(name: "Strudel", price: 7.0, size: 300, imageURL: nil),
    FoodItem(name: "Pie", price: 4.0, size: 200, imageURL: nil)
]

struct ListRowView: View {
    let item: FoodItem
    var body: some View {
        HStack {
            Image(systemName: "bag")
            Text(item.name)
            Spacer()
            VStack(alignment: .trailing) {
                Text("$\(item.price, specifier: "%.2f")")
                Text("Size: \(item.size)g")
            }
        }
    }
}

struct MenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(foodItems) { item in
                        ListRowView(item: item)
                    }
                }
            }
        .navigationBarTitle(Text("Menu"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
