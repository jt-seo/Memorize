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
            Text("\(self.viewModel.theme.themeName), Score: \(viewModel.score)")
                .font(.headline)
                .padding()
            Grid(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation(.linear(duration: self.cardFlipAniDuration)) {
                            self.viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
            }
            .foregroundColor(self.viewModel.theme.color)
                .padding()
            Button(action: {
                withAnimation(.easeInOut(duration: self.newGameAniDuration)) {
                    self.viewModel.resetGame()
                }
            }, label: {Text("New Game")}).padding()
        }
    }
    
    // MARK - Animation constants.
    private let cardFlipAniDuration = 0.6
    private let newGameAniDuration = 0.5
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            self.cardBody(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startAnimationBonusTime() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func cardBody(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime && !card.isMatched {
                        Pie(startAngle: Angle(degrees: 270-animatedBonusRemaining*360), endAngle: Angle(degrees: 270), clockwise: false)
                            .onAppear {
                                self.startAnimationBonusTime()
                            }
                    }
                    else {
                        Pie(startAngle: Angle(degrees: 270-card.bonusRemaining*360), endAngle: Angle(degrees: 270), clockwise: false)
                    }
                }
                .opacity(0.5)
                .padding(5)
                
                Text(card.cardContent)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(.scale)
        }
    }

    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = EmojiMemoryGame()
        viewModel.choose(card: viewModel.cards[0])
        return EmojiMemoryGameView(viewModel: viewModel)
            .environment(\.colorScheme, .dark)
    }
}
