//
//  TypographyScale.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import SwiftUI


struct TypographyScale: Sendable {
    var header: Font
    var title: Font
    var body: Font
    var caption: Font
    var heroAmount: Font

    init(header: Font, title: Font, body: Font, caption: Font, heroAmount: Font) {
        self.header = header
        self.title = title
        self.body = body
        self.caption = caption
        self.heroAmount = heroAmount
    }

    static let base = TypographyScale(
        header: .headline,
        title: .headline,
        body: .subheadline,
        caption: .caption,
        heroAmount: .system(size: 34, weight: .bold)
    )
}
