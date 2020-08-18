//
//  MemoryGame.swift
//  Memorize
//
//  Created by JT2 on 2020/08/13.
//  Copyright © 2020 JT2. All rights reserved.
//

import Foundation

struct MemoryGame<Content: Equatable> {
    var cards: Array<Card>
    var score = 0
    private var prevCard: Card? = nil
    
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
        let cardIndex = self.index(of: card)
        cards[cardIndex].isFaceUp.toggle()
        print("Card chosen\(cardIndex): \(cards[cardIndex])")
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
        return 0
    }
    
    struct Card: Identifiable {
        var isFaceUp = true
        var isMatched = false
        var cardContent: Content
        var id: Int
    }
}
