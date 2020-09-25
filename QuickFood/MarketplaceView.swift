//
//  MarketplaceView.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/7/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

class RestaurantsViewModel: ObservableObject {
    @Published var store: RestaurantsStore = RestaurantsStore()
    
    var restaurants: [RestaurantsStore.Restaurant] {
        store.restaurantsData
    }
    
    init() { }
}

struct MarketplaceView: View {
    @EnvironmentObject var orientationModel: OrientationInfo
    @ObservedObject var RestaurantsVM = RestaurantsViewModel()
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 6) {
                            TitleView()
                                .frame(height: geometry.size.height / 12)
                            ForEach(0..<self.RestaurantsVM.restaurants.count) { restaurantIndex in
                                CardSection(size: geometry.size, restaurant: self.RestaurantsVM.restaurants[restaurantIndex])
                            }
                        }
                    }
                }
                .padding(.top, 1)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .statusBar(hidden: false)
    }
}

struct TitleView: View {
    @State private var isShowingSettingsView = false
    var body: some View {
        ZStack {
            HStack {
                Text("QuickFood")
                    .font(Font.title)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct CardSection: View {
    @EnvironmentObject var orientationModel: OrientationInfo
    let size: CGSize
    let heightFactor: CGFloat = 5/12
    let restaurant: RestaurantsStore.Restaurant
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Text(self.restaurant.name.capitalized)
                        .font(Font.headline)
                        .padding(.leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.restaurant.menu) { item in
                                CardView(size: geometry.size, restaurant: self.restaurant, item: item)
                            }
                            .padding(.bottom)
                            .padding(.top)
                            .padding(.leading)
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.bottom)
        }
        .frame(height: size.height * self.heightFactor)
    }
}

struct CardView: View {
    @EnvironmentObject var orientationModel: OrientationInfo
    let size: CGSize
    let restaurant: RestaurantsStore.Restaurant
    let item: RestaurantsStore.FoodItem
    let heightFactor: CGFloat = 0.7
    @State var menuIsActive = false
    
    init(size: CGSize, restaurant: RestaurantsStore.Restaurant, item: RestaurantsStore.FoodItem) {
        self.size = size
        self.restaurant = restaurant
        self.item = item
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination:
                MenuView(restaurant: self.restaurant)
                    .environmentObject(Order())
                    .environmentObject(self.orientationModel)
                    .navigationBarTitle("Menu", displayMode: .inline),
                isActive: $menuIsActive) { EmptyView() }
            
            ImagePhotoView(imageURL: self.item.imageURL, size: self.size, heightFactor: self.heightFactor)
                .onTapGesture {
                    self.menuIsActive = true
                }
        }
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceView()
        .environmentObject(OrientationInfo())
    }
}
