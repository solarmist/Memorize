//
//  EmojiMemoryGameView.swift
//  Shared
//
//  Created by Joshua Olson on 11/9/20.
//

import SwiftUI

// MARK: - Game View

struct EmojiMemoryGameView: View {
    @ObservedObject var gameView: EmojiMemoryGame
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        if verticalSizeClass == .compact {
            HStack {content()}
        } else {
            VStack {content()}
        }
    }

    @ViewBuilder
    private func content() -> some View {
        Group {
            if gameView.remainingCards > 0 {
                Grid(gameView.cards) { index in
                    CardView(index: index)
                        .onTapGesture {
                            // https://swiftui-lab.com/swiftui-animations-part1/
                            // Only those parameters that depend on a value changed
                            // inside the withAnimation closure will be animated
                            withAnimation(.linear) { gameView.choose(gameView.cards[index]) }
                        }

                }
            } else {
                GeometryReader { geometry in
                    Text("You win")
                        .font(Font.system(size: min(geometry.size.width, geometry.size.height)))
                        .foregroundColor(gameView.secondaryColor)
                }
            }

            Divider()

            ControlsView()
        }.environmentObject(gameView)
    }
}

// MARK: - Controls

struct ControlsView: View {
    @EnvironmentObject var gameView: EmojiMemoryGame
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        if verticalSizeClass == .compact {
            VStack {controls()}
        } else {
            HStack {controls()}
        }
    }

    @ViewBuilder
    private func controls() -> some View {
        Group {
            VStack {
                Text(gameView.themeName).foregroundColor(gameView.secondaryColor)
                Text("New Game")
                    .multilineTextAlignment(.center)
                    .cardify(isFaceUp: true,
                             primaryColor: gameView.primaryColor,
                             secondaryColor: gameView.secondaryColor)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .onTapGesture {
                        withAnimation(.easeInOut) { gameView.newGame() }
                    }
            }
            VStack {
                Text("Hi Score: \(gameView.highScore)")
                Text("Score: \(gameView.score)")
            }.foregroundColor(gameView.secondaryColor)
        }
        .padding()
        // For the roation
//        .animation(.spring())
    }
}

// MARK: - Card View

struct CardView: View {
    @EnvironmentObject var gameView: EmojiMemoryGame
    let index: Int

    var cardIsStillAvailable: Bool {index < gameView.cards.count}
    var card: MemoryGame<String>.Card {gameView.cards[index]}

    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }

    @State private var animatedPercentBonusRemaining: Double = 0
    private func startBonusTimeAnimation() {
        animatedPercentBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedPercentBonusRemaining = 0
        }
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if (cardIsStillAvailable && card.isFaceUp) ||
           !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: startAngle,
                            endAngle: endAngle * -animatedPercentBonusRemaining)
                            .onAppear { startBonusTimeAnimation() }
                    } else {
                        Pie(startAngle: startAngle,
                            endAngle: endAngle * -card.bonusRemaining)
                    }
                }
//                .padding(5)
                .transition(.identity)
                .opacity(pieOpacity)

                Text(verbatim: card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(card.isMatched ? endAngle : startAngle)
                    .animation(
                        card.isMatched
                            ? Animation
                                .linear(duration: rotationDuration)
                                .repeatForever(autoreverses: false)
                                .delay(rotationDelay)
                            : .default)
            }
            .cardify(isFaceUp: card.isFaceUp,
                    primaryColor: gameView.primaryColor,
                    secondaryColor: gameView.secondaryColor)
            // Add or remove card animation
            // TODO: This isn't animating correctly
            .transition(AnyTransition.offset(x: cardOrigin.x, y: cardOrigin.y))
        }
    }

    // MARK: - Drawing Constants
    let startAngle = Angle.degrees(0)
    let endAngle = Angle.degrees(360)
    let cardOrigin = CGPoint(x: -500, y: -500)
    let rotationDelay: Double = 0.25
    let pieOpacity: Double = 0.4
    let rotationDuration: Double = 1

    private func fontSize(for size: CGSize) -> CGFloat {
        // % of the smaller dimension
        min(size.height, size.width) * 0.6
    }
}

// MARK: - Preview Section

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        let languages = ["en", "ja"]
        let languages = ["en"]
        let game = EmojiMemoryGame()
        game.choose(game.cards[0])

        // swiftlint:disable:next identifier_name
        return ForEach(languages, id: \.self) { id in
            EmojiMemoryGameView(gameView: game)
                .environment(\.locale, .init(identifier: id))
        }
    }
}
