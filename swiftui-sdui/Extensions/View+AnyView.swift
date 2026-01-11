//
//  View+AnyView.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
