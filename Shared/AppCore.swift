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
    var internSettingsState: SettingsState?
    var settingsState: SettingsState? {
        get {
            return internSettingsState
        }
        set {
            guard let newValue = newValue else {
                internSettingsState = nil
                return
            }
            if !newValue.isSettingsSheetPresented {
                self.internSettingsState = nil
                return
            }
            internSettingsState = SettingsState(
                isSettingsSheetPresented: newValue.isSettingsSheetPresented,
                subdomain: newValue.subdomain,
                apiKey: newValue.apiKey
            )
        }
    }
    var todayState = RecordTimeState()

    var isSettingsSheetPresented: Bool { internSettingsState != nil }
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
            if env.getMiteAPIKey() == nil || env.getMiteAPIKey() == "" {
                state.isAPIKeyAvailable = false
            } else {
                state.isAPIKeyAvailable = true
            }
            return .none
        case .setNavigationItem(let item):
            state.selectedNavigationItem = item
            return .none
        case .settingsAction:
            return .none
        case .setSheet(presented: true):
            state.settingsState = SettingsState()
            return .none
        case .setSheet(presented: false):
            if env.getMiteAPIKey() == nil || env.getMiteAPIKey() == "" {
                state.isAPIKeyAvailable = false
            } else {
                state.isAPIKeyAvailable = true
            }
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
    ),
    todayReducer.pullback(
        state: \.todayState,
        action: /AppAction.todayAction,
        environment: { _ in RecordTimeEnvironment() }
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
            internSettingsState: SettingsState(
                isSettingsSheetPresented: false,
                subdomain: "quartett-mobile",
                apiKey: "123456789")
        ),
        reducer: appReducer,
        environment: AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    )
}
