//
//  MemoryGame.swift
//  Memorize
//
//  Created by JT2 on 2020/08/13.
//  Copyright © 2020 JT2. All rights reserved.
//

import Foundation

struct MemoryGame<Content> {
    var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> Content) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(cardContent: content, id: pairIndex * 2))
            cards.append(Card(cardContent: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    func choose(card: Card) {
        print("Card chosen: \(card)")
    }
    
    struct Card: Identifiable {
        var isFaceUp = true
        var isMatched = false
        var cardContent: Content
        var id: Int
    }
}
