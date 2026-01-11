//
//  DesignToken.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//
import Foundation

struct DesignToken: Hashable, Codable, Sendable {
    let rawValue: String
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
