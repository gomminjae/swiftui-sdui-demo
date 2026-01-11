//
//  Color+Hex.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import SwiftUI

extension Color {
    init?(hexString: String) {
        let sanitized = hexString
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(.init(charactersIn: "#")))
            .uppercased()

        var value: UInt64 = 0
        guard Scanner(string: sanitized).scanHexInt64(&value) else { return nil }

        let r, g, b, a: UInt64
        switch sanitized.count {
        case 6: // RGB
            (r, g, b, a) = (value >> 16 & 0xFF, value >> 8 & 0xFF, value & 0xFF, 0xFF)
        case 8: // RGBA
            (r, g, b, a) = (value >> 24 & 0xFF, value >> 16 & 0xFF, value >> 8 & 0xFF, value & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static func hex(_ hex: String?, fallback: Color) -> Color {
        guard let hex, let color = Color(hexString: hex) else { return fallback }
        return color
    }
}
