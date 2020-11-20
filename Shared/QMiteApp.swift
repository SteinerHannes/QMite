//
//  QMiteApp.swift
//  Shared
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI

@main
struct QMiteApp: App {
    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            ContentView()
                .frame(minWidth: 700, idealWidth: 900, maxWidth: .infinity, minHeight: 400, idealHeight: 600, maxHeight: .infinity)
        }
        Settings {
            Text("Settings")
                .frame(width: 100, height: 100, alignment: .center)
        }
        #else
        WindowGroup {
            ContentView()
        }
        #endif
    }
}
