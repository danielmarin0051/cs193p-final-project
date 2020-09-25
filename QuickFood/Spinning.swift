//
//  SpinningAndScaling.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

struct Spinning: ViewModifier {
    let period: Double
    @State var isVisible = false
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: self.period)
            .repeatForever(autoreverses: false))
            .onAppear {
                self.isVisible = true
            }
    }
}

extension View {
    func spinning(period: Double = 1.0) -> some View {
        self.modifier(Spinning(period: period))
    }
}
