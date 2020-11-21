//
//  SideBar.swift
//  QMite (macOS)
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI
import ComposableArchitecture

struct SideBar: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                #if os(iOS)
                sidebar
                    .navigationTitle("Navigation")
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                            Button(action: { }, label: {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 22, weight: .light))
                            })
                        }
                        ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                            if !viewStore.isAPIKeyAvailable {
                                Button(action: {
                                    viewStore.send(AppAction.test)
                                }, label: {
                                    HStack(alignment: .center, spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.system(size: 22, weight: .light))
                                            .foregroundColor(.red)
                                        Text("No mite-API key saved yet.")
                                            .foregroundColor(.primary)
                                    }
                                })
                            }
                        }
                    }
                #else
                sidebar
                    .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                            Button(action: { }, label: {
                                if viewStore.isAPIKeyAvailable {
                                    Image(systemName: "person.crop.circle.fill")
                                        .imageScale(.large)
                                } else {
                                    Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                                        .imageScale(.large)
                                        .foregroundColor(.red)
                                        .help(Text("No mite-API key saved yet."))
                                }
                            })
                        }
                    }
                #endif

                if viewStore.isAPIKeyAvailable {
                    Text("Select a Section")
                } else {
                    Text("No mite-API saved yet")
                }
            }
        }
    }

    var sidebar: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(NavigationItem.allCases) { item in
                    NavigationLink(
                        destination: item.view,
                        tag: item,
                        selection: viewStore.binding(
                            get: { $0.selectedNavigationItem },
                            send: AppAction.setNavigationItem(item) )
                    ) {
                        Label(
                            title: { Text(item.userFacingString) },
                            icon: { Image(systemName: item.icon) }
                        )
                    }.tag(item)
                }
            }.listStyle(SidebarListStyle())
        }
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(store: .mock)
    }
}
