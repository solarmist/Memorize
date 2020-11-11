//
//  MemorizeApp.swift
//  Shared
//
//  Created by Joshua Olson on 11/9/20.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            let game = EmojiMemoryGame()
            EmojiMemoryGameView(gameView: game)
        }
    }
}
