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
        
    enum Themes: CaseIterable {
        case halloween, number, face, animal, fruit
        func getDescription() -> String {
            switch (self) {
                case .halloween: return "Halloween Theme"
                case .number: return "Number Theme"
                case .face: return "Face Theme"
                case .animal: return "Animal Theme"
                case .fruit: return "Fruit Theme"
            }
        }
    }
    
    private let emojiList = [Themes.halloween: ["👻", "🎃", "🕷", "🎅", "☃", "👺", "👽"],
                            Themes.number: ["1", "2", "3", "4", "5", "6", "7"],
                            Themes.face: ["😀", "🤬", "😈", "😎", "🥶", "🤡", "🤢"],
                            Themes.animal: ["🐶", "🐱", "🐼", "🐨", "🐒", "🦁", "🐽"],
                            Themes.fruit: ["🍏", "🍎", "🍐", "🍉", "🍌", "🍒", "🍑"]]
    
    private(set) var theme: Themes
    private var numberOfPairs = Int.random(in: 5...10)
    
    init (theme: Themes) {
        self.theme = theme
        
        let emojis = emojiList[theme]!.shuffled()
        model =  MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            emojis[pairIndex % emojis.count]
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
    
    func reset() {
        theme = Themes.allCases.randomElement()!
        numberOfPairs = Int.random(in: 5...10)
        
        let emojis = emojiList[theme]!.shuffled()
        model =  MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            emojis[pairIndex % emojis.count]
        }
    }
}
