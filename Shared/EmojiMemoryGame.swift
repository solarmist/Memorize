//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Joshua Olson on 11/10/20.
//
// The viewModel
//
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private(set) var game: MemoryGame<String>

    init() {
        var (_, theme) = themes.randomElement()!
        theme.icons.shuffle()
        primaryColor = theme.primaryColor
        secondaryColor = theme.secondaryColor
        themeName = theme.name

        game = MemoryGame<String>(
            pairsOfCards: theme.pairs,
            cardContentFactory: {pairIndex in theme.icons[pairIndex]})
    }

    // MARK: - UI Settings
    private(set) var primaryColor: Color = Color.gray
    private(set) var secondaryColor: Color = Color.gray
    private(set) var themeName: LocalizedStringKey = "Default"

    // MARK: - Access to the Model
    // Mark is a meta thing that adds a HR in the file dropdown

    @Published private(set) var highScore: Int = 0
    var remainingCards: Int {game.unmatchedCardsRemaining}
    var cards: [MemoryGame<String>.Card] {game.cards}
    var score: Int {game.score}

    // MARK: - Intent(s)

    func newGame() {
        var (_, theme) = themes.randomElement()!
        theme.icons.shuffle()
        primaryColor = theme.primaryColor
        secondaryColor = theme.secondaryColor
        themeName = theme.name

        game = MemoryGame<String>(
            pairsOfCards: theme.pairs,
            cardContentFactory: {pairIndex in theme.icons[pairIndex]})
    }

    func choose(_ card: MemoryGame<String>.Card) {
        game.choose(card)
        highScore = max(game.score, highScore)
    }

}

struct Theme<Fill: ShapeStyle> {
    var name: LocalizedStringKey
    var icons: [String]
    var primaryColor: Fill
    var secondaryColor: Fill
    var randomizePairs: Bool
    var pairs: Int {randomizePairs ? Int.random(in: 2...icons.count) : icons.count}
}
// LinearGradient, RadialGradient or AngularGradient
let themes = [  // Each of these must be at least 8 emoji long
    "Halloween": Theme(
        name: LocalizedStringKey("Halloween"),
        icons: "🦇,😱,🙀,😈,🎃,👻,🍭,🍬,💀,👺,👽,🕸,🤖,🧛🏻".components(separatedBy: ","),
        primaryColor: Color.orange,
        secondaryColor: Color.black,
        randomizePairs: true),
    "Food": Theme(
        name: LocalizedStringKey("Food"),
        icons: "🍎,🥑,🍠,🥞,🍕,🥪,🌮,🍖,🥝,🥗,🌭,🍜,🍚,🍙,🍟".components(separatedBy: ","),
        primaryColor: Color.red,
        secondaryColor: Color.green,
        randomizePairs: false),
    "Faces": Theme(
        name: LocalizedStringKey("Faces"),
        icons: "😀,☺️,😍,😭,🥶,😡,🤢,🥴,🤑,🤐,😵,😱".components(separatedBy: ","),
        primaryColor: Color.yellow,
        secondaryColor: Color.pink,
        randomizePairs: false),
    "Animals": Theme(
        name: LocalizedStringKey("Animals"),
        icons: "🐥,🐒,🐷,🐹,🐭,🐶,🐨,🐸,🐍,🦀,🐡,🦐,🦂,🕷".components(separatedBy: ","),
        primaryColor: Color.pink,
        secondaryColor: Color.purple,
        randomizePairs: false),
    "Flags": Theme(
        name: LocalizedStringKey("Flags"),
        icons: "🇦🇽,🇧🇩,🇦🇮,🇦🇶,🇨🇦,🇨🇻,🇵🇫,🇫🇴,🇯🇵,🇮🇩,🇱🇧,🇰🇵,🇳🇴,🇹🇿,🇺🇸,🇹🇴,🇻🇳,🇬🇧".components(separatedBy: ","),
        primaryColor: Color.white,
        secondaryColor: Color.red,
        randomizePairs: true),
    "Activities": Theme(
        name: LocalizedStringKey("Activities"),
        icons: "🤸,🏋️,🧘,🤽,🏊,🏄,🏌️,🤾,🚴,🚣,🧗".components(separatedBy: ","),
        primaryColor: Color.yellow,
        secondaryColor: Color.blue,
        randomizePairs: false)
]
