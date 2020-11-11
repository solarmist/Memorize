//
//  MemoryGame.swift
//  Memorize
//
//  Created by Joshua Olson on 11/10/20.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    var cards: [Card]

    mutating func choose(_ card: Card) {
        print("Card chosen: \(card)")
        guard let idx = cards.firstIndex(of: card) else {
            print("Couldn't find card \(card)")
            return
        }
        self.cards[idx].isFaceUp = !cards[idx].isFaceUp
        print("Flipped card \(idx): isFaceUp? \(cards[idx])")
    }

    init(pairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()

        for pairIndex in 0..<pairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }

    struct Card: Identifiable, Equatable {
        static func == (lhs: MemoryGame<CardContent>.Card, rhs: MemoryGame<CardContent>.Card) -> Bool {
            lhs.id == rhs.id
        }

        func isMatch(rhs: MemoryGame<CardContent>.Card) -> Bool {
            content == rhs.content
        }

        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        // swiftlint:disable:next identifier_name
        var id: Int
    }
}
