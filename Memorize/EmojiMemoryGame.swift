//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by JT2 on 2020/08/13.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model = createGame(theme: Themes.halloween)

    enum Themes: CaseIterable {
        case halloween, number, face, animal, fruit
        func getDescription() -> String {
            switch (self) {
                case .halloween: return "Halloween"
                case .number: return "Number"
                case .face: return "Face"
                case .animal: return "Animal"
                case .fruit: return "Fruit"
            }
        }
    }
    
    private static let emojiList = [Themes.halloween: ["👻", "🎃", "🕷", "🎅", "☃", "👺", "👽"],
                            Themes.number: ["1", "2", "3", "4", "5", "6", "7"],
                            Themes.face: ["😀", "🤬", "😈", "😎", "🥶", "🤡", "🤢"],
                            Themes.animal: ["🐶", "🐱", "🐼", "🐨", "🐒", "🦁", "🐽"],
                            Themes.fruit: ["🍏", "🍎", "🍐", "🍉", "🍌", "🍒", "🍑"]]
    
    private static var userTheme: Themes?
    private static let minCardPairs = 2
    private static let maxCardPairs = 5
    private static var numberOfPairs = Int.random(in: minCardPairs...maxCardPairs)
    
    static func createGame(theme: Themes) -> MemoryGame<String> {
        EmojiMemoryGame.userTheme = theme
        let emojis = emojiList[theme]!
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
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
    var theme: Themes {
        get {
            EmojiMemoryGame.userTheme!
        }
        set {
            EmojiMemoryGame.userTheme = newValue
        }
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        EmojiMemoryGame.numberOfPairs = Int.random(in: EmojiMemoryGame.minCardPairs...EmojiMemoryGame.maxCardPairs)
        theme = Themes.allCases.randomElement()!
        model = EmojiMemoryGame.createGame(theme: theme)
    }
}
