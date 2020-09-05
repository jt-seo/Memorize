//
//  ThemeStoreView.swift
//  Memorize
//
//  Created by JT3 on 2020/09/04.
//  Copyright © 2020 JT2. All rights reserved.
//

import SwiftUI

struct ThemeStoreView: View {
    @ObservedObject var store: ThemeStore
    @State private var showThemeEditor = false
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach (store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                        .navigationBarTitle(Text("Memorize"))) {
                            ThemeView(isEditing: self.editMode != EditMode.inactive, theme: theme)
                                .environmentObject(self.store)
                    }
                }
                .onDelete { indexSet in
                    self.store.removeThemes(atOffsets: indexSet)
                }
            }
            .navigationBarTitle(Text("Memorize"))
            .navigationBarItems(leading: Image(systemName: "plus")
                    .onTapGesture {
                        print("set to true")
                        self.showThemeEditor = true
                    }
                    .popover(isPresented: self.$showThemeEditor) {
                        ThemeEditor(showThemeEditor: self.$showThemeEditor, onChanged: self.store.addTheme)
                            .environmentObject(self.store)
                    }
                , trailing: EditButton()
            )
                .environment(\.editMode, self.$editMode)
        }
    }
}

struct ThemeView: View {
    @EnvironmentObject var store: ThemeStore
    var isEditing: Bool = false
    var theme: Theme
    @State private var showEditor = false
    
    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "pencil.circle").imageScale(.large)
                    .foregroundColor(theme.color)
                    .onTapGesture {
                        self.showEditor = true
                    }
                    .opacity(isEditing ? 1 : 0)
                    .popover(isPresented: self.$showEditor) {
                        ThemeEditor(theme: self.theme, showThemeEditor: self.$showEditor) { theme in
                            self.store.updateTheme(for: theme)
                        }
                            .environmentObject(self.store)
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(theme.color)
                    RoundedRectangle(cornerRadius: 10).stroke()
                }.opacity(isEditing ? 0 : 1)
            }.frame(width: 40).foregroundColor(.white)

            VStack(alignment: .leading) {
                Text(theme.name).font(.headline)
                Text(theme.emojiList).font(.caption)
            }
        }
    }
}
