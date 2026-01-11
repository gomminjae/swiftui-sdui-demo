//
//  SpacingScale.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Foundation

struct SpacingScale: Sendable {
    var xs: Double
    var s: Double
    var m: Double
    var l: Double
    var xl: Double
    var page: Double

    init(xs: Double, s: Double, m: Double, l: Double, xl: Double, page: Double) {
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.page = page
    }

    static let base = SpacingScale(xs: 4, s: 8, m: 12, l: 16, xl: 24, page: 16)

    func resolve(_ token: SpacingToken) -> Double {
        switch token {
        case .xs: return xs
        case .s: return s
        case .m: return m
        case .l: return l
        case .xl: return xl
        case .page: return page
        }
    }

    func resolve(raw token: String?, fallback: Double) -> Double {
        guard let token, let t = SpacingToken(rawValue: token) else { return fallback }
        return resolve(t)
    }
}
