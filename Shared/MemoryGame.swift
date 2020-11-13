//
//  MemoryGame.swift
//  Memorize
//
//  Created by Joshua Olson on 11/10/20.
//

import Foundation

struct MemoryGame<CardContent: Equatable & Hashable> {
    public var unmatchedCardsRemaining: Int {cards.count - matchedCards.count}
    private(set) var score = 0

    private(set) var matchedCards = [Card]()
    private(set) var cards: [Card]

    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    mutating func choose(_ card: Card) {
        guard let index = cards.firstIndex(of: card),
              !matchedCards.contains(cards[index]) else {
            return
        }
        print("Card chosen: \(cards[index])")

        processPossibleMatch(index)

        if indexOfOneAndOnlyFaceUpCard != nil {
            self.cards[index].isFaceUp = !cards[index].isFaceUp
        } else {
            indexOfOneAndOnlyFaceUpCard = index
        }
    }

    // If there's a match remove the cards from play and add them to the matchedCards pile
    // Also adjust the score
    mutating func processPossibleMatch(_ index: Int) {
        guard let matchIndex = indexOfOneAndOnlyFaceUpCard,
              matchIndex != index else {
            return
        }

        if cards[matchIndex].content == cards[index].content {
            print("Found a match: \(unmatchedCardsRemaining)")
            matchedCards.append(cards[matchIndex])
            matchedCards.append(cards[index])

            cards[matchIndex].isMatched = true
            cards[index].isMatched = true

//            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
//                self.cards[matchIndex].isFaceUp = false
//                self.cards[index].isFaceUp = false
//            }
//            cards.remove(at: index)
//            cards.remove(at: matchIndex)

            score += 2
        } else if cards[index].indicesSeen.contains(index),
                  cards[matchIndex].indicesSeen.contains(matchIndex) {
            score -= 2
        } else if cards[index].indicesSeen.contains(index) || cards[matchIndex].indicesSeen.contains(matchIndex) {
            score -= 1
        }
        cards[matchIndex].indicesSeen.insert(matchIndex)
        cards[index].indicesSeen.insert(index)
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

    struct Card: Identifiable, Equatable, Hashable {
        static func == (lhs: Card, rhs: Card) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            content.hash(into: &hasher)
        }

        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var indicesSeen = Set<Int>()

        var content: CardContent
        // swiftlint:disable:next identifier_name
        var id: Int
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
