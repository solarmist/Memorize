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
                        .onTapGesture {gameView.choose(gameView.cards[index])}
                }
            } else {
                Text("You win").foregroundColor(gameView.secondaryColor)
            }
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
            VStack {content()}
        } else {
            HStack {content()}
        }
    }

    @ViewBuilder
    private func content() -> some View {
        Group {
            VStack {
                Text(gameView.themeName).foregroundColor(gameView.secondaryColor)
                Text("New Game").multilineTextAlignment(.center)
                    .cardify(isFaceUp: true,
                             primaryColor: gameView.primaryColor,
                             secondaryColor: gameView.secondaryColor)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .onTapGesture {gameView.newGame()}
            }
            VStack {
                Text("Hi Score: \(gameView.highScore)")
                Text("Score: \(gameView.score)")
            }.foregroundColor(gameView.secondaryColor)
        }
        .padding()
        .animation(.default)
    }
}

// MARK: - Card View

struct CardView: View {
    @EnvironmentObject var gameView: EmojiMemoryGame
    let index: Int

    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if gameView.cards[index].isFaceUp ||
           !gameView.cards[index].isMatched {
            ZStack {
                Pie(startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: Double.random(in: 0...360))).padding(5).opacity(0.4)
                    Text(verbatim: gameView.cards[index].content)
                        .font(Font.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: gameView.cards[index].isFaceUp,
                    primaryColor: gameView.primaryColor,
                    secondaryColor: gameView.secondaryColor)
        }
    }

    // MARK: - Drawing Constants
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
