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
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                        Button(action: { }, label: {
                            Image(systemName: "person.fill")
                        })
                    }
                }
            #else
            sidebar
                .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                        Button(action: { }, label: {
                            Image(systemName: "person.fill")
                        })
                    }
                }
            #endif
            Text("Select a Section")
        }
    }
    
    var sidebar: some View {
        List {
            ForEach(NavigationItem.allCases) { item in
                NavigationLink(
                    destination: item.view,
                    label: {
                        Label(
                            title: { Text(item.userFacingString) },
                            icon: { Image(systemName: item.icon) }
                        )
                    }
                )
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
