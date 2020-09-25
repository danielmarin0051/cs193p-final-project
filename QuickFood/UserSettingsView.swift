//
//  UserSettingsView.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

struct UserSettingsView: View {
    @ObservedObject var settings: UserSettingsVM
    @State private var address: String
    @State private var firstName: String
    @State private var lastName: String
    @State private var age: Int
    
    init(settings: UserSettingsVM) {
        self.settings = settings
        _address = State(wrappedValue: settings.userSettings.address ?? "")
        _firstName = State(wrappedValue: settings.userSettings.firstName ?? "")
        _lastName = State(wrappedValue: settings.userSettings.lastName ?? "")
        _age = State(wrappedValue: settings.userSettings.age ?? 18)
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Information")) {
                    TextField("First Name", text: self.$firstName)
                    TextField("First Name", text: self.$lastName)
                    TextField("Address", text: self.$address)
                    Stepper("Age: \(self.age)", value: self.$age, in: 0...100)
                }
                Section {
                    Button(action: {
                        self.settings.addSettings(address: self.address, firstName: self.firstName, lastName: self.lastName, age: self.age)
                    }) {
                        Text("Save")
                    }
                }
            }.navigationBarTitle(Text("Settings"))
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(settings: UserSettingsVM())
    }
}
