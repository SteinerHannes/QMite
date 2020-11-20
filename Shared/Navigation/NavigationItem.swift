import SwiftUI

enum NavigationItem: Identifiable {
    case recordTime
    case statistics
    
    var id: String {
        switch self {
            case .recordTime:
                return "recordTime"
            case .statistics:
                return "statistics"
        }
    }
    
    var view: some View {
        return Text("asdasdasdas")
    }
    
    var userFacingString: String {
        switch self {
            case .recordTime:
                return "Today"
            case .statistics:
                return "Statistics"
        }
    }
    
    var icon: String {
        switch self {
            case .recordTime:
                return "timer"
            case .statistics:
                return "chart.bar.xaxis"
        }
    }
    
}

extension NavigationItem: CaseIterable {
    var allCases : [NavigationItem] {
        return [.recordTime, .statistics]
    }
}
