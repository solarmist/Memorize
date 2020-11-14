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
            cards[index].isFaceUp = !cards[index].isFaceUp
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
            // TODO: Use the bonus score
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

        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var indicesSeen = Set<Int>()

        var content: CardContent
        // swiftlint:disable:next identifier_name
        var id: Int

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {max(0, bonusTimeLimit - faceUpTime)}
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
