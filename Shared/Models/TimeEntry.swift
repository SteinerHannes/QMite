//
//  TimeEntry.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import Foundation

//[
//    {"time_entry": {
//        "billable": true,
//        "created_at":"2020-11-20T14:31:19+01:00",
//        "date_at":"2020-11-20",
//        "id":89884776,
//        "locked":false,
//        "minutes":135,
//        "project_id":3159059,
//        "revenue":null,
//        "hourly_rate":0,
//        "service_id":231427,
//        "updated_at":"2020-11-20T14:32:42+01:00",
//        "user_id":205154,
//        "note":"(14:30 bis 16:45) 🏡",
//        "user_name":"Hannes Steiner",
//        "customer_id":217035,
//        "customer_name":"Audi",
//        "project_name":"401261 - Ecomove",
//        "service_name":"Development"
//        }
//    }
//]

//swiftlint:disable identifier_name
struct TimeEntry: Codable, Identifiable {
    let billable: Bool
    let created_at: Date
    let date_at: Date
    let id: Int
    let locked: Bool
    let minutes: Int
    let project_id: Int
    let revenue: Double?
    let hourly_rate: Int
    let service_id: Int
    let updated_at: Date
    let user_id: Int
    let note: String
    let user_name: String
    let customer_id: Int
    let customer_name: String
    let project_name: String
    let service_name: String
}
//swiftlint:enable identifier_name

extension TimeEntry: Equatable {
    static func == (lhs: TimeEntry, rhs: TimeEntry) -> Bool {
        return lhs.id == rhs.id
    }
}
