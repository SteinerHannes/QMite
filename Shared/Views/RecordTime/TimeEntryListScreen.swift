//
//  TimeEntryListScreen.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import SwiftUI
import ComposableArchitecture

struct TimeEntryListScreen: View {
    let store: Store<RecordTimeState, RecordTimeAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.today) { entry in
                    TimeEntryDetailScreen(entry: entry.time_entry)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onAppear {
                viewStore.send(.getToday)
            }
            .alert(item:
                viewStore.binding(
                    get: { $0.error },
                    send: RecordTimeAction.errorChanged
                )
            ) { error in
                error.alertView
            }
        }
    }
}

struct TimeEntryDetailScreen: View {
    let entry: TimeEntry.TimeEntryContent

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.note)
        }
    }
}

//struct TimeEntryListScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeEntryListScreen(store: Store<RecordTimeState,RecordTimeAction>.mock.)
//    }
//}
