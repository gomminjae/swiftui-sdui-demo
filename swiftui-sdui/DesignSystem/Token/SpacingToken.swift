//
//  SpacingToken.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Foundation

public enum SpacingToken: String, Codable, Sendable {
    case xs = "spacing.xs"
    case s  = "spacing.s"
    case m  = "spacing.m"
    case l  = "spacing.l"
    case xl = "spacing.xl"

    /// 페이지 좌우 패딩 같은 공통 레이아웃용
    case page = "spacing.page"
}
