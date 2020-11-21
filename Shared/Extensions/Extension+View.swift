//
//  Extension+View.swift
//  QMite
//
//  Created by Hannes Steiner on 21.11.20.
//

import SwiftUI

extension View {
    func ereaseToAnyView() -> some View {
        AnyView(self)
    }
}
