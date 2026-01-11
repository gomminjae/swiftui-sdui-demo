//
//  ColorToken.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Foundation

enum ColorToken: String, Codable, Sendable {
    
    // label
    case labelPrimary = "label.primary"
    case labelSecondary = "label.secondary"
    case labelTertiary = "label.tertiary"
    
    case labelInversePrimary = "label.inversePrimary"
    case labelInverseSecondary = "label.inverseSecondary"
    
    // background
    case backgroundPrimary = "background.primary"
    case backgroundSecondary = "background.secondary"
    
    // brand / semantic
    case brandPrimary = "brand.primary"
    case semanticPositive = "semantic.positive"
}
