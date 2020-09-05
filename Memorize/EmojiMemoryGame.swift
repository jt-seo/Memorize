//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by JT2 on 2020/08/13.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    
    private var numberOfPairs: Int
    
    var theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
        numberOfPairs = theme.numberOfPairsOfCards <= theme.emojiList.count ? theme.numberOfPairsOfCards : theme.emojiList.count
        
        let emojiList = theme.emojiList
        
        print("name: \(theme.name), card count: \(numberOfPairs)")
        
        model = MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            let strIdx = emojiList.index(emojiList.startIndex, offsetBy: pairIndex)
            return String(emojiList[strIdx])
        }
    }
    
    // MARK: - Access to the model.
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    var score: Int {
        model.totalScore
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            let strIdx = theme.emojiList.index(theme.emojiList.startIndex, offsetBy: pairIndex)
            return String(theme.emojiList[strIdx])
        }
    }
}
