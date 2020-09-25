//
//  MainView.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var launchScreenIsShowing = true
    var body: some View {
        ZStack {
            if self.launchScreenIsShowing {
                LaunchScreen()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.hideLaunchScreen()
                    }
                }
            } else {
                TabView {
                    MarketplaceView()
                        .environmentObject(OrientationInfo())
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Restaurants")
                        }
                    UserSettingsView(settings: UserSettingsVM())
                        .tabItem {
                            Image(systemName: "square.and.pencil")
                            Text("Settings")
                        }
                }
            }
        }
    }
    private func hideLaunchScreen() {
        withAnimation(.easeInOut) {
            self.launchScreenIsShowing = false
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
