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
    var settingsState: SettingsState?

    var isSettingsSheetPresented: Bool { settingsState != nil }
}

enum AppAction: Equatable {
    case onAppear
    case setNavigationItem(NavigationItem)
    case settingsAction(SettingsAction)
    case setSheet(presented: Bool)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    private enum Keys: String {
        case miteApiKey
    }

    func getMiteAPIKey() -> String? {
        return KeychainWrapper.standard.string(forKey: Keys.miteApiKey.rawValue)
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
        case .settingsAction(.dismiss):
            state.settingsState = nil
            return .none
        case .setSheet(presented: true):
            state.settingsState = SettingsState()
            return .none
        case .setSheet(presented: false):
            state.settingsState = nil
            return .none
        default:
            return .none
    }
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    _appReducer.debug(),
    settingsReducer.optional().pullback(
        state: \.settingsState,
        action: /AppAction.settingsAction,
        environment: { env -> SettingsEnvironment in
            SettingsEnvironment(mainQueue: env.mainQueue)
        }
    )
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
        initialState: AppState(
            isAPIKeyAvailable: true,
            selectedNavigationItem: .recordTime,
            settingsState: SettingsState(
                subdomain: "quartett-mobile",
                apiKey: "123456789")
        ),
        reducer: appReducer,
        environment: AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    )
}
