//
//  Buildable.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Combine
import SwiftUI

final class ComponentActionDispatcher: ObservableObject {
    let subject = PassthroughSubject<ComponentAction, Never>()

    func send(_ action: ComponentAction) {
        subject.send(action)
    }
}

protocol Buildable {
    func build(theme: DesignTheme, dispatcher: ComponentActionDispatcher) -> AnyView
}
