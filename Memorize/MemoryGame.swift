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
                if (!cards[index].isMatched) {
                    cards[index].isFaceUp = index == newValue
                }
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
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(of: card), !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
            addFlippedCard(card.cardContent)
            if let prevIndex = prevCardIndex {
                if (cards[chosenIndex].cardContent == cards[prevIndex].cardContent) {
                    cards[chosenIndex].isMatched = true
                    cards[prevIndex].isMatched = true
                    totalScore += 2
                    print("Card matched! \(cards[chosenIndex]), \(cards[prevIndex]) Score: \(totalScore)")
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
        var isFaceUp = false
        var isMatched = false
        var cardContent: Content
        var id: Int
    }
}
