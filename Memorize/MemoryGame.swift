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
//        if (card.isMatched == false && card.isFaceUp == false) {
//            guard let index = cards.firstIndex(of: card) else {
//                print("No matching card! \(card)")
//                return
//            }
//            cards[index].toggleCard()
//
//            if prevCard != nil {
//                if prevCard!.cardContent == card.cardContent && prevCard!.id != card.id {
//                    // Find matching cards!
//                    score += 5
//                    print("Find matching card.")
//                }
//                else {
//                    cards[index].toggleCard()
//                    guard let prevIndex = cards.firstIndex(of: prevCard!) else {
//                        print("No matching previous card! \(card)")
//                        return
//                    }
//                    cards[prevIndex].toggleCard()
//                    print("Card is not matching.")
//                    prevCard = nil
//                }
//            }
//            else {
//                prevCard = card
//            }
//        }
        print("Card chosen: \(card)")
    }
    
    struct Card: Identifiable, Equatable {
        static func == (lhs: MemoryGame<Content>.Card, rhs: MemoryGame<Content>.Card) -> Bool {
            return lhs.id == rhs.id
        }
        
        var isFaceUp = true
        
        mutating func toggleCard() {
            isFaceUp.toggle()
        }
        var isMatched = false
        var cardContent: Content
        var id: Int
    }
}
