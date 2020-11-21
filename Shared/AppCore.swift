//
//  AppCore.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    
}

enum AppAction: Equatable {
    
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

private let _appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
        @unknown default:
        return .none
    }
}
