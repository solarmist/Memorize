//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Joshua Olson on 11/10/20.
//
// The viewModel
//
import SwiftUI

let themes: [String: Theme] = [
    // Each of these must be at least 8 emoji long
    "Halloween": Theme(
        name: ("Halloween"),
        icons: "🦇😱🙀😈🎃👻🍭🍬💀👺👽🕸🤖🧛🏻",
        primaryColor: UIColor.orange,
        secondaryColor: UIColor.black),
    "Food": Theme(
        name: ("Food"),
        icons: "🍎🥑🍠🥞🍕🥪🌮🍖🥝🥗🌭🍜🍚🍙🍟",
        primaryColor: UIColor.red,
        secondaryColor: UIColor.green),
    "Faces": Theme(
        name: ("Faces"),
        icons: "😀☺️😍😭🥶😡🤢🥴🤑🤐😵😱",
        primaryColor: UIColor.yellow,
        secondaryColor: UIColor.brown),
    "Animals": Theme(
        name: ("Animals"),
        icons: "🐥🐒🐷🐹🐭🐶🐨🐸🐍🦀🐡🦐🦂🕷",
        primaryColor: UIColor.brown,
        secondaryColor: UIColor.purple),
    "Flags": Theme(
        name: ("Flags"),
        icons: "🇦🇽🇧🇩🇦🇮🇦🇶🇨🇦🇨🇻🇵🇫🇫🇴🇯🇵🇮🇩🇱🇧🇰🇵🇳🇴🇹🇿🇺🇸🇹🇴🇻🇳🇬🇧",
        primaryColor: UIColor.white,
        secondaryColor: UIColor.red),
    "Activities": Theme(
        name: ("Activities"),
        icons: "🤸🏋️🧘🤽🏊🏄🏌️🤾🚴🚣🧗",
        primaryColor: UIColor.yellow,
        secondaryColor: UIColor.blue)
]

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
        print("\(theme.json?.utf8 ?? "nil"))")
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
        // TODO: - Make the cards hidden before having the new game.
        game.reset()

        var (_, theme) = themes.randomElement()!
        theme.icons.shuffle()
        primaryColor = theme.primaryColor
        secondaryColor = theme.secondaryColor
        themeName = theme.name

        game = MemoryGame<String>(
            pairsOfCards: theme.pairs,
            cardContentFactory: {pairIndex in theme.icons[pairIndex]})
        print("\(theme.json?.utf8 ?? "nil"))")
    }

    func choose(_ card: MemoryGame<String>.Card) {
        game.choose(card)
        highScore = max(game.score, highScore)
    }

}

struct Theme: Hashable, Codable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.name == rhs.name &&
                lhs.icons == rhs.icons &&
                lhs.primaryColor == rhs.primaryColor &&
                lhs.secondaryColor == rhs.secondaryColor &&
                lhs.pairs == rhs.pairs
        )
    }

    init(
        name: String,
        icons: String,
        primaryColor: UIColor,
        secondaryColor: UIColor
    ) {
        self.rawName = name
        self.icons = icons.map(String.init)
        self.primaryRGB = primaryColor.rgb
        self.secondaryRGB = secondaryColor.rgb
    }

    init?(json: Data?) throws {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(Theme.self, from: json!) {
            self = newEmojiArt
        } else {
            // Only return nil if it fails to load
            return nil
        }
    }

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    var rawName: String
    var icons: [String]
    var primaryRGB: UIColor.RGB
    var secondaryRGB: UIColor.RGB

    var pairs: Int { icons.count }
    var name: LocalizedStringKey { LocalizedStringKey(rawName) }
    var primaryColor: Color { Color.init(primaryRGB) }
    var secondaryColor: Color { Color.init(secondaryRGB) }

}

extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))
    }
}

extension UIColor {
    public struct RGB: Hashable, Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }

    convenience init(_ rgb: RGB) {
        self.init(red: rgb.red,
                  green: rgb.green,
                  blue: rgb.blue,
                  alpha: rgb.alpha)
    }

    public var rgb: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red,
                   green: green,
                   blue: blue,
                   alpha: alpha)
    }
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
