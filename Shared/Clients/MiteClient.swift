//
//  MiteClient.swift
//  QMite
//
//  Created by Hannes Steiner on 22.11.20.
//

import Foundation
import ComposableArchitecture

struct MiteClient {
    var getToday: () -> Effect<[TimeEntry], MiteClientError>
    var getDay: (String) -> Effect<[TimeEntry], MiteClientError>
    var getThisWeek: () -> Effect<[[TimeEntry]], MiteClientError>

    enum MiteClientError: Error, Equatable, Identifiable {
        var id: String {
            switch self {
                case .miteErrorDescription:
                    return "miteErrorDescription"
                case .error:
                    return "error"
                case .decodeError:
                    return "decodeError"
            }
        }

        case miteErrorDescription(String)
        case error(String)
        case decodeError(String)
    }

    struct MiteError: Decodable {
        let error: String
    }
}

extension MiteClient {
    static func decodeError(error: Error) -> MiteClientError {
        do {
            guard let errorData = Data(base64Encoded: error.localizedDescription) else {
                return MiteClientError.error(error.localizedDescription)
            }
            let miteError = try jsonDecoder.decode(MiteError.self, from: errorData)
            return MiteClientError.miteErrorDescription(miteError.error)
        } catch {
            return MiteClientError.decodeError(error.localizedDescription)
        }
    }

    static let live = MiteClient { () -> Effect<[TimeEntry], MiteClientError> in
        var request = baseUrlRequest
        request.httpMethod = HTTPMethod.get.rawValue
        request.url!.appendPathComponent("daily.json") //swiftlint:disable:this force_unwrapping
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in
                print(String(bytes: data, encoding: .utf8) as Any)
                return data
            }
            .decode(type: [TimeEntry].self, decoder: jsonDecoder)
            .mapError { error -> MiteClientError in
                return decodeError(error: error)
            }.eraseToEffect()
    } getDay: { date -> Effect<[TimeEntry], MiteClientError> in
        var request = baseUrlRequest
        request.httpMethod = HTTPMethod.get.rawValue
        request.url!.appendPathComponent("daily\(date).json") //swiftlint:disable:this force_unwrapping
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in
                print(String(bytes: data, encoding: .utf8) as Any)
                return data
            }
            .decode(type: [TimeEntry].self, decoder: jsonDecoder)
            .mapError { error -> MiteClientError in
                MiteClientError.miteErrorDescription(error.localizedDescription)
            }.eraseToEffect()
    } getThisWeek: { () -> Effect<[[TimeEntry]], MiteClientError> in
        var request = baseUrlRequest
        request.httpMethod = HTTPMethod.get.rawValue
        request.url!.appendPathComponent("time_entries.json?at=this_week") //swiftlint:disable:this force_unwrapping
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in
                print(String(bytes: data, encoding: .utf8) as Any)
                return data
            }
            .decode(type: [[TimeEntry]].self, decoder: jsonDecoder)
            .mapError { error -> MiteClientError in
                MiteClientError.miteErrorDescription(error.localizedDescription)
            }.eraseToEffect()
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PATCH"
    case delete = "DELETE"
}

private let baseUrlRequest: URLRequest = {
    let subdomain = UserDefaults.standard.string(forKey: Keys.subdomain.rawValue) ?? ""
    let baseUrl = URL(string: "https://\(subdomain).mite.yo.lk/")! //swiftlint:disable:this force_unwrapping
    var request = URLRequest(url: baseUrl, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 3.0)

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let key = KeychainWrapper.standard.string(forKey: Keys.miteApiKey.rawValue)
    request.setValue(key, forHTTPHeaderField: "X-MiteApiKey")
    return request
}()

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    //decoder.dateDecodingStrategy = .formatted(utcDateFormatter)
    return decoder
}()

private let utcDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()

private let onlyDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()
