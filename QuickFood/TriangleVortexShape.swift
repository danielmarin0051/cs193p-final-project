//
//  HexagonShape.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import SwiftUI

struct TriangleVortexShape: Shape {
    var sides: Double
    var initialAngle: Double
    let shouldFit: Bool
    
    init(sides: Double, initialAngle: Double = 0.0, shouldFit: Bool = false) {
        self.sides = sides
        self.initialAngle = Angle(degrees: initialAngle).radians
        self.shouldFit = shouldFit
    }
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, initialAngle) }
        set {
            sides = newValue.first
            initialAngle = newValue.second
        }
    }
    
    let mult: CGFloat = 1.15
    let factor: CGFloat = 20
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let initLength = min(rect.size.width, rect.size.height) / 2.0
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var points = [CGPoint]()
        
        let extra: Int = sides != Double(Int(sides)) ? 1 : 0
        
        for i in 0..<Int(self.sides) + extra {
            if i <= 2 {
                let length = initLength / self.factor
                let angle = -Angle(degrees: 120 * Double(i)).radians + initialAngle
                let point = CGPoint(x: center.x + length * CGFloat(cos(angle)), y: center.y + length * CGFloat(sin(angle)))
                if (i == 0) {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
                points.append(point)
            } else {
                let curr = points.last!
                let next = points[i - 3]
                let angle = Angle(p1: curr, p2: next).radians
                let length = distanceBetween(p1: curr, p2: next) * self.mult
                let realNextPoint = CGPoint(x: curr.x + length * CGFloat(cos(angle)), y: curr.y + length * CGFloat(sin(angle)))
                points.append(realNextPoint)
                if self.shouldFit && (length * CGFloat(cos(angle)) >= rect.width || length * CGFloat(sin(angle)) >= rect.height) {
                    path.addLine(to: next)
                    break
                }
                path.addLine(to: realNextPoint)
            }
        }
        return path
    }
    
    func distanceBetween(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(pow(p2.x - p1.x, 2.0) + pow(p2.y - p1.y, 2.0))
    }
}

extension Angle {
    init(p1: CGPoint, p2: CGPoint) {
        let num = (p2.y - p1.y)
        let den = (p2.x - p1.x)
        var radians = atan(Double( num / den ))
        if den < 0 {
            radians += Angle(degrees: 180).radians
        }
        self.init(radians: radians)
    }
}

struct Demo: View {
    @State private var numSides: Double = 10
    @State private var angle: Double = 0
    var body: some View {
        TriangleVortexShape(sides: self.numSides, initialAngle: self.angle)
            .stroke(Color.blue, lineWidth: 2)
            .border(Color.black)
            .onAppear {
                withAnimation(.easeOut(duration: 5)) {
                    self.numSides = 100
                    self.angle = 360
                }
            }
    }
}

struct TriangleVortexShape_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}
