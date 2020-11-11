//
//  EmojiMemoryGameView.swift
//  Shared
//
//  Created by Joshua Olson on 11/9/20.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var gameView: EmojiMemoryGame

    var body: some View {
        HStack {
            ForEach(gameView.cards.indices) { index in
//                Text("\(String(gameView.cards[index].isFaceUp))")
                CardView(index: index)
                    .environmentObject(gameView)
                    .onTapGesture(perform: {gameView.choose(gameView.cards[index])})
            }
            .foregroundColor(Color.orange)
            .font(gameView.cards.count / 2 < 5 ? Font.largeTitle : Font.body)
        }
    }
}

struct CardView: View {
    @EnvironmentObject var gameView: EmojiMemoryGame
    var index: Int

    var body: some View {
//        Text("\(String(gameView.cards[index].isFaceUp))")
        GeometryReader { geometry in
            ZStack {
                if gameView.cards[index].isFaceUp {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3.0)
                    Text(verbatim: gameView.cards[index].content)
                 } else {
                    RoundedRectangle(cornerRadius: 10.0).fill()
                }
            }.frame(height: geometry.size.width * 3/2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        let languages = ["en", "ja"]
        let languages = ["en"]
        let game = EmojiMemoryGame()

        // swiftlint:disable:next identifier_name
        ForEach(languages, id: \.self) { id in
            EmojiMemoryGameView(gameView: game)
                .environment(\.locale, .init(identifier: id))
        }
//        EmojiMemoryGameView()
    }

}
