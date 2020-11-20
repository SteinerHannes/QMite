//
//  SideBar.swift
//  QMite (macOS)
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI

struct SideBar: View {
    @State private var selectedNavigationItem: NavigationItem = .recordTime 
    
    var body: some View {
        List {
            ForEach(NavigationItem.allCases) { item in
                NavigationLink(item.userFacingString, destination: item.view)
                    .tag(item)
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
