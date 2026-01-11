//
//  DesignTheme.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import SwiftUI

struct DesignTheme: Sendable {
    var colors: ColorPalette
    var spacing: SpacingScale
    var radius: RadiusScale
    var typography: TypographyScale

    init(
        colors: ColorPalette,
        spacing: SpacingScale,
        radius: RadiusScale,
        typography: TypographyScale
    ) {
        self.colors = colors
        self.spacing = spacing
        self.radius = radius
        self.typography = typography
    }

    static let toss = DesignTheme(
        colors: .base,
        spacing: .base,
        radius: .base,
        typography: .base
    )

    func color(_ token: ColorToken) -> Color {
        colors.resolve(token)
    }

    func color(raw token: String?, fallback: Color = .primary) -> Color {
        colors.resolve(raw: token, fallback: fallback)
    }

    func spacing(_ token: SpacingToken) -> Double {
        spacing.resolve(token)
    }

    func spacing(raw token: String?, fallback: Double) -> Double {
        spacing.resolve(raw: token, fallback: fallback)
    }

    func radius(_ token: RadiusToken) -> Double {
        radius.resolve(token)
    }

    func radius(raw token: String?, fallback: Double) -> Double {
        radius.resolve(raw: token, fallback: fallback)
    }
}
