//
//  TabBar.swift
//  QMite (iOS)
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedNavigationItem: NavigationItem = .recordTime
    
    var body: some View {
        TabView {
            ForEach(NavigationItem.allCases) { item in
                item.view
                    .tabItem { Label(item.userFacingString, image: item.icon) }
                    .tag(item)
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
