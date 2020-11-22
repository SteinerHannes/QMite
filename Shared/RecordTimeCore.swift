//
//  RecordTimeCore.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import SwiftUI
import ComposableArchitecture

typealias MiteError = MiteClient.MiteClientError

struct RecordTimeState: Equatable {
    var today: [TimeEntry] = []
    var error: MiteError?
}

enum RecordTimeAction: Equatable {
    case getToday
    case getTodayResponse(Result<[TimeEntry], MiteError>)
    case errorChanged(MiteError?)
}

struct RecordTimeEnvironment {
    var miteClient: MiteClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let recordTimeReducer = Reducer<RecordTimeState, RecordTimeAction, RecordTimeEnvironment> { state, action, env in
    switch action {
        case .errorChanged(let error):
            state.error = error
            return .none
        case .getToday:
            struct GetDayId: Hashable {}

            return env.miteClient.getToday()
                .receive(on: env.mainQueue)
                .catchToEffect()
                .map(RecordTimeAction.getTodayResponse)
                .cancellable(id: GetDayId(), cancelInFlight: true)
        case .getTodayResponse(let result):
            switch result {
                case .success(let today):
                    state.today = today
                case .failure(let miteError):
                    state.error = miteError
            }
            return .none
    }
}

extension MiteClient.MiteClientError {
    var alertView: Alert {
        switch self {
            case .miteErrorDescription(let text):
                return Alert(title: Text("Mite Error"), message: Text(text), dismissButton: .cancel())
            case .decodeError(let text):
                return Alert(title: Text("Decode Error"), message: Text(text), dismissButton: .cancel())
            case .error(let text):
                return Alert(title: Text("Bad Error"), message: Text(text), dismissButton: .cancel())
        }
    }
}
