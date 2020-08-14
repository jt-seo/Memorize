//
//  ContentView.swift
//  Memorize
//
//  Created by JT2 on 2020/08/11.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    var body: some View {
        HStack {
            ForEach (viewModel.cards) {card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
            }
        }
            .font(.largeTitle)
            .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        ZStack {
            if (card.isFaceUp) {
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.cardContent)
            }
            else
            {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: EmojiMemoryGame())
                .environment(\.colorScheme, .dark)
        }
    }
}
