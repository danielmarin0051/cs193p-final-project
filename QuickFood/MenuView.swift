//
//  ContentView.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/7/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

struct ItemOrder: Identifiable, Codable {
    var items = [RestaurantsStore.FoodItem : Int]()
    var noteString = ""
    let id = UUID()
    
    var totalPrice: Double {
        var counter: Double = 0.0
        for (item, count) in self.items {
            counter += item.price * Double(count)
        }
        return counter
    }
    
    var numItems: Int {
        Array(items.values).reduce(0, +)
    }
}

class Order: ObservableObject {
    @Published var order: ItemOrder = ItemOrder()
    var items: [RestaurantsStore.FoodItem:Int] {
        order.items
    }
    var totalPrice: Double {
        self.order.totalPrice
    }
    
    var numItems: Int {
        self.order.numItems
    }
    
    var noteString: String {
        get {
            self.order.noteString
        }
        set {
            self.order.noteString = newValue
        }
    }
    
    func setItemCount(item: RestaurantsStore.FoodItem, count: Int) {
        order.items[item] = count
    }
    
    func addOneItem(item: RestaurantsStore.FoodItem) {
        if order.items[item] != nil {
            order.items[item]! += 1
        } else {
            order.items[item] = 1
        }
    }
    
    func removeOneItem(item: RestaurantsStore.FoodItem) {
        if order.items[item] != nil {
            if order.items[item]! > 0 {
                order.items[item]! -= 1
            } else {
                order.items[item] = nil
            }
        }
    }
    
    func itemCount(for item: RestaurantsStore.FoodItem) -> Int {
        order.items[item] ?? 0
    }
}

struct ListRowView: View {
    @EnvironmentObject var order: Order
    @EnvironmentObject var orientationModel: OrientationInfo
    let item: RestaurantsStore.FoodItem
    @State private var popoverIsShowing = false
    @State private var sliderValue = 0.0
    let heightFactor: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ImagePhotoView(imageURL: self.item.imageURL, size: geometry.size, heightFactor: self.heightFactor)
                    .onTapGesture {
                        self.popoverIsShowing = true
                }
                
                VStack(alignment: .leading) {
                    Text(self.item.name)
                    Text("Size: \(self.item.size)g")
                        .font(Font.caption)
                    Text("$\(self.item.price, specifier: "%.2f")")
                        .font(Font.callout)
                }
                Spacer()
                HStack {
                    Text("\(self.numItems)")
                    if (self.numItems > 0) {
                        Image(systemName: "minus")
                            .imageScale(.medium)
                            .foregroundColor(.red)
                            .frame(width: 25, height: 25)
                            .overlay(Circle().stroke(Color.red))
                            .onTapGesture {
                                self.order.removeOneItem(item: self.item)
                        }
                    }
                    Image(systemName: "plus")
                        .imageScale(.medium)
                        .foregroundColor(.green)
                        .frame(width: 25, height: 25)
                        .overlay(Circle().stroke(Color.green))
                        .onTapGesture {
                            if self.numItems < 30 {
                                self.order.addOneItem(item: self.item)
                            }
                    }
                }
                .animation(.easeInOut)
            }
            .sheet(isPresented: self.$popoverIsShowing, onDismiss: {
                self.order.setItemCount(item: self.item, count: Int(self.sliderValue))
            }) {
                GeometryReader { geo in
                    if self.orientationModel.orientation == .portrait {
                        VStack {
                            ImageViewWithGestures(imageURL: self.item.imageURL, size: geo.size, widthFactor: 1.0)
                            ModalFoodView(item: self.item, sliderValue: self.$sliderValue, popoverIsShowing: self.$popoverIsShowing)
                        }
                    } else {
                        HStack {
                            ImageViewWithGestures(imageURL: self.item.imageURL, size: geo.size, widthFactor: 0.5)
                            ModalFoodView(item: self.item, sliderValue: self.$sliderValue, popoverIsShowing: self.$popoverIsShowing)
                                .padding(.vertical)
                        }
                    }
                }
            }
        }
    }
    
    var numItems: Int {
        order.itemCount(for: self.item)
    }
}

struct ImageViewWithGestures: View {
    let imageURL: String?
    let size: CGSize
    let widthFactor: CGFloat
    @State private var zoomScale: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    var body: some View {
        ImagePhotoView(imageURL: self.imageURL, size: self.size, widthFactor: self.widthFactor)
            .offset(self.panOffset)
            .gesture(
                DragGesture()
                    .onChanged { self.panOffset = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            self.panOffset = .zero
                        }
                    }
            )
            .scaleEffect(self.zoomScale)
            .gesture(
                MagnificationGesture()
                .onChanged { self.zoomScale = $0 }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        self.zoomScale = 1.0
                    }
                }
            )
    }
}

struct ModalFoodView: View {
    let item: RestaurantsStore.FoodItem
    @Binding var sliderValue: Double
    @Binding var popoverIsShowing: Bool
    var body: some View {
        VStack {
            Text(self.item.name.capitalized).font(.largeTitle)
            Spacer()
            VStack(alignment: .center) {
                Text("How many?")
                HStack {
                    Text("\(Int(0.0))")
                    Slider(value: self.$sliderValue, in: 0...30)
                    Text("\(Int(30))")
                }
                .padding()
                Text("\(Int(self.sliderValue))")
            }
            Spacer()
            Button(action: {
                self.popoverIsShowing = false
            }) {
                Text("Save")
            }
            .buttonStyle(GradientButtonStyle())
            Spacer()
        }
    }
}

// Custom button style, credit to https://www.simpleswiftguide.com/advanced-swiftui-button-styling-and-animation/
struct GradientButtonStyle: ButtonStyle {
    let leadingColor: Color
    let trailingColor: Color
    init(leadingColor: Color = Color.red, trailingColor: Color = Color.orange) {
        self.leadingColor = leadingColor
        self.trailingColor = trailingColor
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding([.vertical])
            .padding([.horizontal], 50)
            .background(LinearGradient(gradient: Gradient(colors: [self.leadingColor, self.trailingColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct MenuView: View {
    @EnvironmentObject var order: Order
    @EnvironmentObject var orientationModel: OrientationInfo
    @State var showConfirmation = false
    @State var confirmationMessage = ""
    @State var userNote = ""
    let restaurant: RestaurantsStore.Restaurant
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 20) {
                            TextField("Leave any notes to the chef here!", text: self.$userNote)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            ForEach(self.restaurant.menu) { item in
                                ListRowView(item: item)
                                    .frame(height: geometry.size.height / (self.orientationModel.orientation == .portrait ? 10 : 3))
                                    .padding(.horizontal)
                            }
                        }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                self.order.noteString = self.userNote
                                self.placeOrder()
                            }) {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                    Text("Submit Order: $\(self.order.totalPrice, specifier: "%.2f")")
                                }
                            }
                            .buttonStyle(GradientButtonStyle())
                            .padding(.bottom)
                            .disabled(self.order.numItems < 1)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .alert(isPresented: self.$showConfirmation) {
            Alert(title: Text("Order submitted successfully"),
                  message: Text(self.confirmationMessage),
                  dismissButton: .default(Text("Got it!")))
        }
    }
    
    // Credit to Paul Hudson, 2019 for the outline of this function that submits a POST
    // request to https://reqres.in/api/orders, simluating what would be done when a user
    // submits his/her order
    func placeOrder() {
        print("Placing order...")
        guard let encodedOrder = try? JSONEncoder().encode(self.order.order) else {
            print("Could not encode order")
            return
        }
        
        print("Encoded Order sent")
        
        let url = URL(string: "https://reqres.in/api/orders")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedOrder
        
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            if data == nil {
                print("No data")
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(ItemOrder.self, from: data!) {
                print("Decoded order received: ")
                print("\(decodedOrder)")
                self.confirmationMessage = "Your order for \(decodedOrder.numItems) item\(decodedOrder.numItems > 1 ? "s" : "") is on its way!"
                if decodedOrder.noteString.count > 0 {
                    self.confirmationMessage += "\nYour note: \"\(decodedOrder.noteString)\""
                }
                self.showConfirmation = true
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let restaurant = RestaurantsStore.Restaurant(name: "Jiangnan Cuisine", menu: [
            RestaurantsStore.FoodItem(name: "Chocolate Cake", price: 10.0, size: 1000, imageURL: "https://live.staticflickr.com/65535/49983403076_efbef3f54f_c.jpg"),
            RestaurantsStore.FoodItem(name: "Vanilla Ice cream", price: 3.0, size: 200, imageURL: "https://live.staticflickr.com/65535/49983211706_5583877b0e_c.jpg"),
            RestaurantsStore.FoodItem(name: "Oreo Cookie", price: 2.0, size: 50, imageURL: "https://live.staticflickr.com/65535/49983471257_c6822c1721.jpg"),
            RestaurantsStore.FoodItem(name: "Strudel", price: 7.0, size: 300, imageURL: "https://live.staticflickr.com/65535/49983212016_490d49cacb_c.jpg"),
        ])
        return NavigationView {
            MenuView(restaurant: restaurant)
                .environmentObject(Order())
                .environmentObject(OrientationInfo())
                .navigationBarTitle(Text("Menu for \(restaurant.name.capitalized)"), displayMode: .inline)
        }
    }
}
