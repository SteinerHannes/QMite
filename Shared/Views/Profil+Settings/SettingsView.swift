//
//  SettingsView.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: Store<SettingsState, SettingsAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            content
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    var content: some View {
        #if os(iOS)
            return NavigationView {
                settingsList
                    .listStyle(InsetGroupedListStyle())
                    .navigationBarTitle(Text("Settings"))
            }
        #else
        return VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            settingsList
                .listStyle(DefaultListStyle())
                .padding()
                .presentedWindowStyle(TitleBarWindowStyle())
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                        Button {
                            ViewStore(store).send(.dismiss)
                        } label: {
                            Text("Done")
                        }
                    }
                }
        }.frame(width: 500, height: 400)
        .padding()
        #endif
    }

    var settingsList: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section(header: Text("Subdomain"), footer: Text(viewStore.baseUrl)) {
                    TextField("Subdomain",
                        text: viewStore.binding(
                            get: { $0.subdomain },
                            send: SettingsAction.subdomainChanged
                        )
                    )
                }
                Section(header: Text("mite-API key"), footer: apiFooter) {
                    SecureField("mite-API key",
                        text: viewStore.binding(
                            get: { $0.apiKey },
                            send: SettingsAction.apiKeyChanged
                        )
                    )
                }
            }
        }
    }

    var apiFooter: some View {
        Text("Every existing ") +
        Text("mite").italic() +
        Text(".user can activate the API in his or her user settings:\n") +
        Text("Please click on your user name in the upper right-hand corner of the ") +
        Text("mite").italic() +
        Text(".interface.")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(store: .mock)
    }
}
