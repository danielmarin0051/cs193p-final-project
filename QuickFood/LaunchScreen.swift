//
//  LaunchScreen.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var numSides: Double = 30
    @State private var angle: Double = 0.0
    @State private var blur: CGFloat = 0.0
    var body: some View {
        ZStack {
            Color(red: 0.5, green: 0.5, blue: 0.7, opacity: 0.0)
            TriangleVortexShape(sides: self.numSides, initialAngle: self.angle)
                .stroke(Color.blue, lineWidth: 2)
                .blur(radius: self.blur)
                .blur(radius: self.blur)
                .onAppear {
                    playSound(soundFile: "intro_sound", type: "mp3")
                    withAnimation(.easeOut(duration: 5)) {
                        self.numSides = 100
                        self.blur = 2
                        self.angle = 360
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
