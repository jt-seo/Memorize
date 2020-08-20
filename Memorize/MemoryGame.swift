//
//  MemoryGame.swift
//  Memorize
//
//  Created by JT2 on 2020/08/13.
//  Copyright © 2020 JT2. All rights reserved.
//

import Foundation

struct MemoryGame<Content> where Content: Equatable {
    private(set) var cards: Array<Card>
    private(set) var totalScore = 0
    private var prevCardIndex: Int? {
        get {
            cards.indices.filter{ index in cards[index].isFaceUp && !cards[index].isMatched }.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    private var flippedCards = [Content]()
    private var scoreForOneTurn = 0 {
        didSet(newValue) {
            print("scoreForOneTurn: \(newValue)")
        }
    }
    private mutating func addFlippedCard(_ content: Content) {
        if let _ = flippedCards.firstIndex(of: content) {
            scoreForOneTurn -= 1
        } else {
            flippedCards.append(content)
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> Content) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(cardContent: content, id: pairIndex * 2))
            cards.append(Card(cardContent: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    private func printFlippedCards() {
        for content in flippedCards {
            print(content, terminator: " ")
        }
        print("")
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(of: card), !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
            addFlippedCard(card.cardContent)
            if let prevIndex = prevCardIndex {
                if (cards[chosenIndex].cardContent == cards[prevIndex].cardContent) {
                    cards[chosenIndex].isMatched = true
                    cards[prevIndex].isMatched = true
                    totalScore += 2
                    print("Card matched! \(cards[chosenIndex]), \(cards[prevIndex]) Score: \(totalScore)")
                    flippedCards.removeAll { $0 == card.cardContent }
                    printFlippedCards()
                }
                else {
                    totalScore += scoreForOneTurn
                    print("Card not matched! \(cards[chosenIndex]), \(cards[prevIndex]), scoreThisTurn: \(scoreForOneTurn), totalScore: \(totalScore)")
                }
                cards[chosenIndex].isFaceUp = true
                scoreForOneTurn = 0
            }
            else {
                prevCardIndex = chosenIndex
                print("Card chosen: \(cards[chosenIndex])")
            }
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var cardContent: Content
        var id: Int
        
        // MARK - Bonus time
        var bonusTimeLimit: TimeInterval = 6
        
        // How long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate, !isMatched {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }
            else {
                return pastFaceUpTime
            }
        }
        
        // The last time that this card was turned face up. (and is still face up)
        var lastFaceUpDate: Date?
        
        // The accumulated time that this card has been face up in the past.
        // Not including the current time if is is face up currently.
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            return max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            return bonusTimeLimit > 0 ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        // Whether the card matched during the bonus time period.
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // Whether we are currently face up and has not used up the bonus window.
        var isConsumingBonusTime: Bool {
            isFaceUp && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state.
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime && lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card transitions to face down state. (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
