//
//  File.swift
//  Memorize
//
//  Created by Joshua Olson on 11/11/20.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var primaryColor: Color = Color.orange
    var secondaryColor: Color = Color.black

    func body(content: Content) -> some View {
            ZStack {
                if isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(primaryColor).opacity(0.6)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: borderThickness)
                    content.accentColor(primaryColor)
                } else {
                    Group {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(LinearGradient(gradient: Gradient(colors: [primaryColor, secondaryColor]),
                                                 startPoint: .bottomTrailing,
                                                 endPoint: .topLeading))
                        RoundedRectangle(cornerRadius: cornerRadius).stroke(
                            LinearGradient(gradient: Gradient(colors: [secondaryColor, primaryColor]),
                                           startPoint: .topTrailing,
                                           endPoint: .bottomLeading),
                            lineWidth: borderThickness)

                    }
                }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .foregroundColor(secondaryColor)
        .padding(borderPadding)
        .rotation3DEffect(rotationDirection(), axis: rotationVector)
        .animation(.default)
//        .animation(Animation.easeInOut(duration: 3))
    }

    // MARK: - Drawing Constants
    private let aspectRatio: CGFloat = 2/3
    private let cornerRadius: CGFloat = 10
    private let borderPadding: CGFloat = 5
    private let borderThickness: CGFloat = 3
    // swiftlint:disable:next large_tuple
    private let rotationVector: (CGFloat, CGFloat, CGFloat) = (x: 0, y: 1, z: 0)

    private func rotationDirection() -> Angle {
        isFaceUp ? Angle(degrees: 0): Angle(degrees: 180)
    }
}

extension View {
    func cardify(isFaceUp: Bool,
                 primaryColor: Color = Color.orange,
                 secondaryColor: Color = Color.black) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp,
                              primaryColor: primaryColor,
                              secondaryColor: secondaryColor))
    }
}
