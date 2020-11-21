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
        WithViewStore(store) { viewStore in
            content
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: { $0.isSettingsSheetPresented },
                        send: AppAction.setSheet(presented: )
                    )
                ) {
                    IfLetStore(
                        self.store.scope(
                            state: { $0.settingsState },
                            action: AppAction.settingsAction
                        )
                    ) { store in
                        SettingsView(store: store)
                    }
                }
        }
    }

    var content: some View {
        WithViewStore(store) { _ in
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .mock)
    }
}
