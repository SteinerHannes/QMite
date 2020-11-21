//
//  QMiteApp.swift
//  Shared
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI
import ComposableArchitecture

@main
struct QMiteApp: App {
    let store: Store<AppState, AppAction> = .live

    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            ContentView(store: store)
                .frame(minWidth: 400, maxWidth: 600, minHeight: 400, maxHeight: 600)
        }.windowStyle(TitleBarWindowStyle())
        #else
        WindowGroup {
            ContentView(store: store)
        }
        #endif
    }
}
