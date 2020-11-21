import SwiftUI
import ComposableArchitecture

enum NavigationItem: Identifiable, Hashable {
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

    func view(store: Store<AppState, AppAction>) -> some View {
        switch self {
            case .recordTime:
                return RecordTimeView(store: store).ereaseToAnyView()
            case .statistics:
                return Text("Statistics").ereaseToAnyView()
        }
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
    var allCases: [NavigationItem] {
        return [.recordTime, .statistics]
    }
}
