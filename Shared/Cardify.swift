//
//  File.swift
//  Memorize
//
//  Created by Joshua Olson on 11/11/20.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double = 0
    var isFaceUp: Bool {rotation < 90}
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue}
    }
    var fillStyle: Gradient {Gradient(colors: [primaryColor, secondaryColor])}
    var primaryColor: Color
    var secondaryColor: Color

    init(isFaceUp: Bool,
         primaryColor: Color = Color.white,
         secondaryColor: Color = Color.white
    ) {
        rotation = isFaceUp ? 0 : 180
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        print(fillStyle)
    }

    func body(content: Content) -> some View {
        ZStack {
            // Card front
            Group {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                content
                    .accentColor(primaryColor)

            }.opacity(isFaceUp ? show : hide)
            // Card back
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(LinearGradient(gradient: fillStyle,
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .opacity(isFaceUp ? hide : show)
            // Border
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(gradient: fillStyle,
                                   startPoint: .bottomTrailing,
                                   endPoint: .topLeading),
                    lineWidth: borderThickness)
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .foregroundColor(secondaryColor)
        .padding(borderPadding)
        .transition(.identity)
        .rotation3DEffect(Angle.degrees(rotation), axis: rotationVector)
    }

    // MARK: - Drawing Constants
    private let hide: Double = 0
    private let show: Double = 1
    private let aspectRatio: CGFloat = 2/3
    private let cornerRadius: CGFloat = 10
    private let borderPadding: CGFloat = 5
    private let borderThickness: CGFloat = 3
    // swiftlint:disable:next large_tuple
    private let rotationVector: (CGFloat, CGFloat, CGFloat) = (x: 0, y: 1, z: 0)
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
