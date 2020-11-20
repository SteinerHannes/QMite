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
        NavigationView {
            #if os(iOS)
            sidebar
                .navigationTitle("Navigation")
            #else
            sidebar
                .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
                .navigationTitle("Navigation")
            #endif
            Text("Select a Section")
        }
    }
    
    var sidebar: some View {
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
