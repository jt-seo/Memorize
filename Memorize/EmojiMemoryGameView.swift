//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by JT2 on 2020/08/11.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        VStack {
            Text("\(viewModel.theme.getDescription()), Score: \(viewModel.score)")
                .font(.headline)
                .padding()
            Grid(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        self.viewModel.choose(card: card)
                    }
                    .padding(5)
            }
                .foregroundColor(colorList[viewModel.theme])
                .padding()
            Button("New Game", action: {
                self.viewModel.reset()
                }).padding()
        }
    }
    
    // MARK: - Theme constants.
    private let colorList = [EmojiMemoryGame.Themes.halloween: Color.orange,
                             EmojiMemoryGame.Themes.number: Color.blue,
                             EmojiMemoryGame.Themes.face: Color.pink,
                             EmojiMemoryGame.Themes.animal: Color.yellow,
                             EmojiMemoryGame.Themes.fruit: Color.green]
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            self.cardBody(for: geometry.size)
        }
    }
    
    private func cardBody(for size: CGSize) -> some View {
        ZStack {
            if (card.isFaceUp) {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.cardContent)
            }
            else
            {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: EmojiMemoryGame.Themes.face))
                .environment(\.colorScheme, .dark)
        }
    }
}
