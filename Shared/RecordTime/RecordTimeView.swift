//
//  RecordTimeView.swift
//  QMite
//
//  Created by Hannes Steiner on 20.11.20.
//

import SwiftUI

extension View {
    func ereaseToAnyView() -> some View {
        AnyView(self)
    }
}

struct RecordTimeView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            NavigationView {
                recordTime
                    .navigationTitle(NavigationItem.recordTime.userFacingString)
            }.ereaseToAnyView()
        } else {
            recordTime
                .ereaseToAnyView()
        }
        #else
        recordTime
            .ereaseToAnyView()
        #endif
        
    }
    
    var recordTime: some View {
        Text("hallo")
    }
}

struct RecordTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RecordTimeView()
    }
}
