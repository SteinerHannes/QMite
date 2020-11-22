//
//  TimeEntry.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import Foundation

//swiftlint:disable identifier_name
struct TimeEntry: Codable, Identifiable {
    let time_entry: TimeEntryContent

    struct TimeEntryContent: Codable, Identifiable {
        let billable: Bool
        let created_at: String // Date
        let date_at: String // Date
        let id: Int
        let locked: Bool
        let minutes: Int
        let project_id: Int?
        let revenue: Double?
        let hourly_rate: Int
        let service_id: Int?
        let updated_at: String // Date
        let user_id: Int
        let note: String
        let user_name: String
        let customer_id: Int?
        let customer_name: String?
        let project_name: String?
        let service_name: String?
        let tracking: Tracking?

        struct Tracking: Codable {
            let since: String // Date
            let minutes: Int
        }
    }

    var id: Int {
        self.time_entry.id
    }
}
//swiftlint:enable identifier_name

extension TimeEntry: Equatable {
    static func == (lhs: TimeEntry, rhs: TimeEntry) -> Bool {
        return lhs.id == rhs.id
    }
}
