//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Joshua Olson on 11/10/20.
//
// The viewModel
//
import SwiftUI

let themes = [  // Each of these must be at least 8 emoji long
    "halloween": "🦇,😱,🙀,😈,🎃,👻,🍭,🍬,💀,👺,👽,🕸,🤖,🧛🏻".components(separatedBy: ","),
    "food": "🍎,🥑,🍠,🥞,🍕,🥪,🌮,🍖,🥝,🥗,🌭,🍜,🍚,🍙,🍟".components(separatedBy: ","),
    "faces": "😀,☺️,😍,😭,🥶,😡,🤢,🥴,🤑,🤐,😵,😱".components(separatedBy: ","),
    "animals": "🐥,🐒,🐷,🐹,🐭,🐶,🐨,🐸,🐍,🦀,🐡,🦐,🦂,🕷".components(separatedBy: ","),
    "flags": "🇦🇽,🇧🇩,🇦🇮,🇦🇶,🇨🇦,🇨🇻,🇵🇫,🇫🇴,🇯🇵,🇮🇩,🇱🇧,🇰🇵,🇳🇴,🇹🇿,🇺🇸,🇹🇴,🇻🇳,🇬🇧".components(separatedBy: ","),
    "activities": "🤸,🏋️,🧘,🤽,🏊,🏄,🏌️,🤾,🚴,🚣,🧗".components(separatedBy: ",")
]

class EmojiMemoryGame: ObservableObject {
    @Published private(set) var game: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()

    static func createMemoryGame() -> MemoryGame<String> {
        var (_, emojis) = themes.randomElement()!
        emojis.shuffle()

        return MemoryGame<String>(pairsOfCards: Int.random(in: 2...5),
                                  cardContentFactory: { pairIndex in emojis[pairIndex]})
    }

    // MARK: - Access to the Model
    // Mark is a meta thing that adds a HR in the file dropdown

    var cards: [MemoryGame<String>.Card] {game.cards}

    // MARK: - Intent(s)

    func choose(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }

}
