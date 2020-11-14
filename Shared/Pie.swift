//
//  Pie.swift
//  Memorize
//
//  Created by Joshua Olson on 11/11/20.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = true

    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }

    // By default this will be oriented as a clock face
    func path(in rect: CGRect) -> Path {
        let offSet = Angle.degrees(90)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat((startAngle - offSet).radians)),
            y: center.y + radius * sin(CGFloat((startAngle - offSet).radians))
        )

        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle - offSet,
            endAngle: endAngle - offSet,
            clockwise: clockwise)
        path.addLine(to: center)

        return path
    }
}

struct Pie_Previews: PreviewProvider {
    static var previews: some View {
        Pie(startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 270)
        ).fill(Color.pink)
        .padding()
        .opacity(0.4)
    }
}
