//
//  ThemeEditor.swift
//  Memorize
//
//  Created by JT3 on 2020/09/04.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    @EnvironmentObject var store: ThemeStore
    var theme: Theme?
    let id: UUID
    
    @Binding var showThemeEditor: Bool
    
    @State private var themeName: String = ""
    @State private var emojiList: String = ""
    @State private var numberOfCardPairs: String = ""
    @State private var emojiColor: UIColor?
    @State private var showAlert = false
    
    init (theme: Theme? = nil, showThemeEditor: Binding<Bool>, onChanged: @escaping (Theme) -> Void) {
        self.theme = theme
        _showThemeEditor = showThemeEditor
        self.onChanged = onChanged
        self.id = theme?.id ?? UUID()
    }
    
    private var onChanged: (Theme) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack{
                Text("Theme Editor").padding()
                HStack {
                    Spacer()
                    Text("Done").padding()
                        .onTapGesture {
                            if self.getAlertMessage() == nil {
                                self.showThemeEditor = false // close this window
                                self.callOnChanged()
                            } else {
                                self.showAlert = true
                            }
                    }
                    .alert(isPresented: self.$showAlert) {
                        Alert(title: Text("Edit Theme"), message: Text(self.getAlertMessage() ?? ""), dismissButton: .default(Text("OK")))
                    }
                    
                    Image(systemName: "xmark.square").imageScale(.large).padding()
                        .onTapGesture {
                            self.showThemeEditor = false
                        }
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Theme Name", text: self.$themeName, onEditingChanged: { began in
                        self.callOnChanged()
                    })
                    TextField("Edit Emoji", text: self.$emojiList, onEditingChanged: { began in
                        self.callOnChanged()
                    })
                    TextField("Number of pairs of the cards", text: self.$numberOfCardPairs, onEditingChanged: { began in
                        self.callOnChanged()
                    })
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Select Color")) {
                    Grid(self.store.colorTable, id: \.self) { color in
                        ColorView(color: color, isSelected: self.emojiColor == color ? true : false)
                            .onTapGesture {
                                self.emojiColor = color
                                self.callOnChanged()
                            }
                    }
                    .frame(height: self.height)
                }
            }
        }
        .onAppear {
            if let theme = self.theme {
                self.themeName = theme.name
                self.emojiList = theme.emojiList
                self.emojiColor = theme._color.wrapped
                self.numberOfCardPairs = String(theme.numberOfPairsOfCards)
            }
        }
    }
    
    private var height: CGFloat {
        CGFloat((store.colorTable.count / 6 + 1) * 70)
    }
    
    private func getAlertMessage() -> String? {
        var string: String? = nil
        if themeName.isEmpty {
            string = "Please input the name of the theme."
        }
        else if emojiList.count <= 2 {
            string = "Please add more than 2 emojis."
        }
        else if let numCards = Int(numberOfCardPairs), numCards <= 2 || numCards > emojiList.count{
            string = """
                The number of pairs is invalid.
                It should be greater than 2 and less than the count of emojis.
                Current value is: \(numCards) and emoji count is \(emojiList.count).
                """
        }
        else if emojiColor == nil {
            string = "Please select the emoji"
        }
        return string
    }
    
    func checkParametersValid() -> Bool {
        if themeName.isEmpty || emojiList.count <= 2 || emojiColor == nil {
            return false
        }
        else if let numCards = Int(numberOfCardPairs), numCards <= 2 {
            return false
        }
        return true
    }
    
    func callOnChanged() {
        if checkParametersValid() == true  {
            let theme = Theme(id: self.id, name: themeName, emojiList: emojiList, color: self.emojiColor ?? UIColor.orange, numberOfPairsOfCards: Int(numberOfCardPairs) ?? emojiList.count)
            if let old = self.theme {
                if old == theme {
                    print("Theme is not changed")
                    return
                }
            }
            print("call onChanged: \(theme)")
            onChanged(theme)
        }
    }
}

struct ColorView: View {
    var color: UIColor
    var isSelected: Bool

    var body: some View {
        ZStack {
            Color(color)
                .frame(width: 50, height: 50)
            Group {
                RoundedRectangle(cornerRadius: 10).fill(Color(color))
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 4).foregroundColor(.green)
            }.opacity(self.isSelected ? 1 : 0)
        }
    }
}
