//
//  ColorPaletre.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import SwiftUI

struct ColorPalette: Sendable {
    // label
    var labelPrimary: Color
    var labelSecondary: Color
    var labelTertiary: Color

    var labelInversePrimary: Color
    var labelInverseSecondary: Color

    // background
    var backgroundPrimary: Color
    var backgroundSecondary: Color

    // brand / semantic
    var brandPrimary: Color
    var semanticPositive: Color

    init(
        labelPrimary: Color,
        labelSecondary: Color,
        labelTertiary: Color,
        labelInversePrimary: Color,
        labelInverseSecondary: Color,
        backgroundPrimary: Color,
        backgroundSecondary: Color,
        brandPrimary: Color,
        semanticPositive: Color
    ) {
        self.labelPrimary = labelPrimary
        self.labelSecondary = labelSecondary
        self.labelTertiary = labelTertiary
        self.labelInversePrimary = labelInversePrimary
        self.labelInverseSecondary = labelInverseSecondary
        self.backgroundPrimary = backgroundPrimary
        self.backgroundSecondary = backgroundSecondary
        self.brandPrimary = brandPrimary
        self.semanticPositive = semanticPositive
    }

    /// 앱의 기본 팔레트(초기값)
    static var base: ColorPalette {
        .init(
            labelPrimary: .primary,
            labelSecondary: .secondary,
            labelTertiary: Color.secondary.opacity(0.75),
            labelInversePrimary: .white,
            labelInverseSecondary: Color.white.opacity(0.85),
            backgroundPrimary: Color(uiColor: .systemBackground),
            backgroundSecondary: Color(uiColor: .secondarySystemBackground),
            brandPrimary: .blue,
            semanticPositive: .green
        )
    }

    // MARK: - Resolve
    func resolve(_ token: ColorToken) -> Color {
        switch token {
        case .labelPrimary: return labelPrimary
        case .labelSecondary: return labelSecondary
        case .labelTertiary: return labelTertiary
        case .labelInversePrimary: return labelInversePrimary
        case .labelInverseSecondary: return labelInverseSecondary
        case .backgroundPrimary: return backgroundPrimary
        case .backgroundSecondary: return backgroundSecondary
        case .brandPrimary: return brandPrimary
        case .semanticPositive: return semanticPositive
        }
    }

    func resolve(raw token: String?, fallback: Color = .primary) -> Color {
        guard let token, let t = ColorToken(rawValue: token) else { return fallback }
        return resolve(t)
    }
}
