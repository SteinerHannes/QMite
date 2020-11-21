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
                    recordTime
                        .navigationTitle(NavigationItem.recordTime.userFacingString)
                        .navigationBarItems(trailing:
                            Button(action: { viewStore.send(.setSheet(presented: true)) }, label: {
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
                        )
                }.ereaseToAnyView()
            }
        } else {
            recordTime
                .ereaseToAnyView()
        }
        #else
        recordTime
            .ereaseToAnyView()
        #endif
    }

    var recordTime: some View {
        Text("hallo")
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        RecordTimeView(store: .mock)
    }
}
