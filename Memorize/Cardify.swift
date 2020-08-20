//
//  Cardify.swift
//  Memorize
//
//  Created by JT3 on 2020/08/19.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    var isFaceUp: Bool {
        rotation < 90
    }
    init (isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    func body(content: Content) -> some View {
        ZStack {
            // In case of if - else, the content view is not exist on the screen when isMatched flag is changed to true.
            // That is the reason why the implicit animation (rotation) on the content is not working.
            // By using the opacity track, now that the content view is always on the screen, the rotation animation will work.
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill().transition(.identity)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
