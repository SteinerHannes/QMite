//
//  RecordTimeCore.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import Foundation
import ComposableArchitecture

struct RecordTimeState: Equatable {
    var today: [TimeEntry] = []
}

enum RecordTimeAction: Equatable {
}

struct RecordTimeEnvironment {
}

let todayReducer = Reducer<RecordTimeState, RecordTimeAction, RecordTimeEnvironment> { _, action, _ in
    switch action {
    }
}
