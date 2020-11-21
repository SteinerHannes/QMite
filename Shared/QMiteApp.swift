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
                .frame(minWidth: 700, idealWidth: 900, maxWidth: .infinity, minHeight: 400, idealHeight: 600, maxHeight: .infinity)
        }
        Settings {
            Text("Settings")
                .frame(width: 100, height: 100, alignment: .center)
        }
        #else
        WindowGroup {
            ContentView(store: store)
        }
        #endif
    }
}
