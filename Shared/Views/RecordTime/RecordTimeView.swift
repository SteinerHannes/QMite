//
//  RecordTimeView.swift
//  QMite
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI
import ComposableArchitecture

struct RecordTimeView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    let store: Store<AppState, AppAction>

    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            WithViewStore(store) { viewStore in
                NavigationView {
                    TimeEntryListScreen(store:
                        store.scope(
                            state: { $0.recordTimeState },
                            action: AppAction.recordTimeAction
                        )
                    )
                    .navigationTitle(NavigationItem.recordTime.userFacingString)
                    .navigationBarItems(trailing:
                        Button(action: { viewStore.send(.setSheet(presented: true)) }, label: {
                            if viewStore.isAPIKeyAvailable {
                                Image(systemName: "person.crop.circle.fill")
                                    .imageScale(.large)
                            } else {
                                Image(systemName: "person.crop.circle.fill.badg.exclamationmark")
                                    .imageScale(.large)
                                    .foregroundColor(.red)
                                    .help(Text("No mite-API key saved yet."))
                            }
                        })
                    )
                }.ereaseToAnyView()
            }
        } else {
            TimeEntryListScreen(store:
                store.scope(
                    state: { $0.recordTimeState },
                    action: AppAction.recordTimeAction
                )
            )
            .ereaseToAnyView()
        }
        #else
        TimeEntryListScreen(store:
            store.scope(
                state: { $0.recordTimeState },
                action: AppAction.todayAction
            )
        )
        .ereaseToAnyView()
        #endif
    }
}

struct RecordTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RecordTimeView(store: .mock)
    }
}
