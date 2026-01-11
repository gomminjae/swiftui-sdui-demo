//
//  AppRoute.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Foundation

enum AppRoute: Hashable {
    case notifications
    case settings
    case unknown(String)

    init?(urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        guard url.scheme == "app" else { return nil }
        let destination = url.host ?? ""
        switch destination {
        case "notifications":
            self = .notifications
        case "settings":
            self = .settings
        default:
            self = .unknown(urlString)
        }
    }

    var title: String {
        switch self {
        case .notifications:
            return "알림"
        case .settings:
            return "설정"
        case .unknown(let value):
            return value
        }
    }
}
