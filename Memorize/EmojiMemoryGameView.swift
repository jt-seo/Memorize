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
            Pie(startAngle: Angle(degrees: 90-90), endAngle: Angle(degrees: 360-90), clockwise: false)
                .opacity(0.5)
                .padding(5)
            Text(card.cardContent)
                .font(Font.system(size: fontSize(for: size)))
        }
            .cardify(isFaceUp: card.isFaceUp)
        
    }

    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = EmojiMemoryGame(theme: EmojiMemoryGame.Themes.face)
        viewModel.choose(card: viewModel.cards[0])
        return EmojiMemoryGameView(viewModel: viewModel)
            .environment(\.colorScheme, .dark)
    }
}
