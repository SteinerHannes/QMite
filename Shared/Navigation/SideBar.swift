//
//  SideBar.swift
//  QMite (macOS)
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI

struct SideBar: View {
    var body: some View {
        List {
            Text("")
        }.listStyle(SidebarListStyle())
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
