//
//  TabBar.swift
//  QMite (iOS)
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI
import ComposableArchitecture

struct TabBar: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: { $0.selectedNavigationItem },
                    send: AppAction.setNavigationItem
                )
            ) {
                ForEach(NavigationItem.allCases) { item in
                    item.view
                    .tabItem {
                        Text(item.userFacingString)
                        Image(systemName: item.icon)
                    }
                    .tag(item)
                }
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(store: .mock)
    }
}
