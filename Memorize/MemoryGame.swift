//
//  MemoryGame.swift
//  Memorize
//
//  Created by JT2 on 2020/08/13.
//  Copyright © 2020 JT2. All rights reserved.
//

import Foundation

struct MemoryGame<Content> where Content: Equatable {
    var cards: Array<Card>
    var score = 0
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
            if let prevIndex = prevCardIndex {
                if (cards[chosenIndex].cardContent == cards[prevIndex].cardContent) {
                    cards[chosenIndex].isMatched = true
                    cards[prevIndex].isMatched = true
                    print("Card matched! \(cards[chosenIndex]), \(cards[prevIndex])")
                }
                else {
                    print("Card not matched! \(cards[chosenIndex]), \(cards[prevIndex])")
                }
                cards[chosenIndex].isFaceUp = true
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
