//
//  ContentView.swift
//  Shared
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI

struct ContentView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabBar()
        } else {
            SideBar()
        }
        #else
        SideBar()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
