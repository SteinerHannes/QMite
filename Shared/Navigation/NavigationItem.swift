import SwiftUI

enum NavigationItem {
    case week
    case statistics
}

extension NavigationItem: CaseIterable {
    var allCases : [NavigationItem] {
        return [.week, .statistics]
    }
}
