//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by JT3 on 2020/08/26.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameTheme {
    struct Theme {
        let theme: ThemeType
        let emojiList: String
        let color: Color
        
        var themeName: String {
            theme.getDescription()
        }
        var numberOfPairsOfCards: Int {
            emojiList.count
        }
    }
    
    static var randomTheme: Theme {
        self.themeList[Int.random(in: 0..<themeList.count)]
    }
    
    private static let themeList = createThemeList()
    
    private static func createThemeList() -> [Theme] {
        var themeList = [Theme]()
        for theme in ThemeType.allCases {
            if let emojiList = emojiList[theme], let color = colorList[theme] {
                themeList.append(Theme(theme: theme, emojiList: emojiList, color: color))
            }
        }
        return themeList
    }

    enum ThemeType: CaseIterable {
        case halloween, number, face, animal, fruit, vihicle
        func getDescription() -> String {
            switch (self) {
                case .halloween: return "Halloween"
                case .number: return "Number"
                case .face: return "Face"
                case .animal: return "Animal"
                case .fruit: return "Fruit"
                case .vihicle: return "Vihicle"
            }
        }
    }
    
    private static let emojiList = [ThemeType.halloween: "👻🎃🕷🎅☃👺👽",
                            ThemeType.number: "12345678910",
                            ThemeType.face: "😀😈😎🥶🤡🤢",
                            ThemeType.animal: "🐶🐱🐼🐨🐒🦁🐽",
                            ThemeType.fruit: "🍏🍎🍐🍉🍌🍒🍑",
                            ThemeType.vihicle: "🚗🚌🏎🚑🚝✈️🛰🚟🛴🏍"]
    
    private static let colorList = [ThemeType.halloween: Color.orange,
                             ThemeType.number: Color.blue,
                             ThemeType.face: Color.pink,
                             ThemeType.animal: Color.yellow,
                             ThemeType.fruit: Color.green,
                             ThemeType.vihicle: Color.gray]
}
