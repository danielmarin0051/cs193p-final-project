//
//  UserSettingsModel.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import Foundation
import Combine

struct UserSettings: Codable {
    var address: String?
    var firstName: String?
    var lastName: String?
    var age: Int?
    
    init(address: String? = nil, firstName: String? = nil, lastName: String? = nil, age: Int? = nil) {
        self.address = address
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newSettings = try? JSONDecoder().decode(UserSettings.self, from: json!) {
            self = newSettings
        } else {
            return nil
        }
    }
}

class UserSettingsVM: ObservableObject {
    @Published var userSettings: UserSettings
    private var autosaveCancellable: AnyCancellable?
    static private let defaultsKey = "userSettings"
    
    init() {
        self.userSettings = UserSettings(json: UserDefaults.standard.data(forKey: Self.defaultsKey)) ?? UserSettings()
        autosaveCancellable = $userSettings.sink { settings in
            print("\(settings.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(settings.json, forKey: Self.defaultsKey)
        }
    }
    
    func addSettings(address: String? = nil, firstName: String? = nil, lastName: String? = nil, age: Int? = nil) {
        self.userSettings.address = address
        self.userSettings.firstName = firstName
        self.userSettings.lastName = lastName
        self.userSettings.age = age
    }
}
