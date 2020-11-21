//
//  SettingsCore.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import Foundation
import ComposableArchitecture

struct SettingsState: Equatable {
    var subdomain: String = ""
    var apiKey: String = ""

    var baseUrl: String {
        return "https://\(subdomain).mite.yo.lk/"
    }
}

enum SettingsAction: Equatable {
    case onAppear
    case subdomainChanged(String)
    case apiKeyChanged(String)
    case dismiss
}

struct SettingsEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    private enum Keys: String {
        case miteApiKey
        case subdomain
        case firstLaunch
    }

    func getMiteAPIKey() -> String {
        return KeychainWrapper.standard.string(forKey: Keys.miteApiKey.rawValue) ?? ""
    }

    func setMiteAPIKey(for value: String) {
        KeychainWrapper.standard.set(value, forKey: Keys.miteApiKey.rawValue)
    }

    func getSubDomain() -> String {
        return UserDefaults.standard.string(forKey: Keys.subdomain.rawValue) ?? ""
    }

    func setSubDomain(for value: String) {
        UserDefaults.standard.setValue(value, forKey: Keys.subdomain.rawValue)
    }

    func alreadyLaunched() -> Bool {
        if !UserDefaults.standard.bool(forKey: Keys.firstLaunch.rawValue) {
            UserDefaults.standard.set(true, forKey: Keys.firstLaunch.rawValue)
            return false
        }
        return true
    }
}

let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, env in
    switch action {
        case .onAppear:
            if !env.alreadyLaunched() {
                env.setSubDomain(for: "quartett-mobile")
            }
            state.apiKey = env.getMiteAPIKey()
            state.subdomain = env.getSubDomain()
            return .none
        case .subdomainChanged(let domain):
            env.setSubDomain(for: domain)
            state.subdomain = domain
            return .none
        case .apiKeyChanged(let key):
            env.setMiteAPIKey(for: key)
            state.apiKey = key
            return .none
        case .dismiss:
            return .none
    }
}

extension Store where State == SettingsState, Action == SettingsAction {
    static let mock: Store<SettingsState, SettingsAction> = Store<AppState, AppAction>.mock.scope(
        state: { $0.settingsState! }, //swiftlint:disable:this force_unwrapping 
        action: AppAction.settingsAction
    )
}
