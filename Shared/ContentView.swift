//
//  ContentView.swift
//  Shared
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    let store: Store<AppState, AppAction>

    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabBar(store: store)
        } else {
            SideBar(store: store)
        }
        #else
        SideBar(store: store)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .mock)
    }
}
