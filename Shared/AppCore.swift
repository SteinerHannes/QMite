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
    var selectedNavigationItem: NavigationItem = .recordTime
}

enum AppAction: Equatable {
    case onAppear
    case setNavigationItem(NavigationItem)
    case test
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
        case .setNavigationItem(let item):
            state.selectedNavigationItem = item
            return .none
        case .test:
            state.isAPIKeyAvailable.toggle()
            return .none
    }
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    _appReducer.debug()
)

extension Store where State == AppState, Action == AppAction {
    static let live: Store<AppState, AppAction> = .init(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    )

    static let mock: Store<AppState, AppAction> = .init(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    )
}
