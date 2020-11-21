//
//  AppCore.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var isAPIKeyAvailable: Bool = false
}

enum AppAction: Equatable {
    case onAppear
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    private enum Keys: String {
        case miteApiKey
    }

    func getMiteAPIKey() -> String? {
        return KeychainWrapper.standard.string(forKey: Keys.miteApiKey.rawValue)
    }

    func setMiteAPIKey(for value: String) {
        KeychainWrapper.standard.set(value, forKey: Keys.miteApiKey.rawValue)
    }
}

private let _appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
    switch action {
        case .onAppear:
            if env.getMiteAPIKey() == nil {
                state.isAPIKeyAvailable = false
            } else {
                state.isAPIKeyAvailable = true
            }

            return .none
    }
}
