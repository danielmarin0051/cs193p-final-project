//
//  HexagonShape.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

// Do not check this file, it does not add anything to the project
// It is just here because it might be useful in the future.

//import SwiftUI
//
//struct HexagonShape: Shape {
//    var numSides = 6
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let apothem = min(rect.size.width, rect.size.height) / 2.0
//        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
//
//        for i in 0..<self.numSides {
//            let angleRadians = (CGFloat(i) * (360.0 / CGFloat(self.numSides))) * (CGFloat.pi / 180)
//            let point = CGPoint(x: center.x + CGFloat(cos(angleRadians) * apothem), y: center.y + CGFloat(sin(angleRadians) * apothem))
//
//            if i == 0 {
//                path.move(to: point)
//            } else {
//                path.addLine(to: point)
//            }
//        }
//        path.closeSubpath()
//        return path
//    }
//}
//
//struct HexagonShape_Previews: PreviewProvider {
//    static var previews: some View {
//        HexagonShape()
//    }
//}
