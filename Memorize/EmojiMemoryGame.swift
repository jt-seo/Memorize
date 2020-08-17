//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by JT2 on 2020/08/13.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame {
    private var model = createEmojiGame()
    
    static let numberOfPairs = Int.random(in: 2...5)
    
    private static func createEmojiGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷", "🎅", "☃"].shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            emojis[pairIndex % emojis.count]
        }
    }
    
    // MARK: - Access to the model.
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
