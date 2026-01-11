//
//  RadiusScale.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//
import Foundation


struct RadiusScale: Sendable {
    var s: Double
    var m: Double
    var l: Double

    init(s: Double, m: Double, l: Double) {
        self.s = s
        self.m = m
        self.l = l
    }

    static let base = RadiusScale(s: 10, m: 14, l: 18)

    func resolve(_ token: RadiusToken) -> Double {
        switch token {
        case .s: return s
        case .m: return m
        case .l: return l
        }
    }

    func resolve(raw token: String?, fallback: Double) -> Double {
        guard let token, let t = RadiusToken(rawValue: token) else { return fallback }
        return resolve(t)
    }
}
