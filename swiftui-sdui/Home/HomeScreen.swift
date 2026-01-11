//
//  HomeScreen.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Foundation
import SwiftUI

struct HomeScreen: Decodable, Sendable {
    let screenKey: String
    let navBar: NavBarConfiguration?
    let backgroundColor: String?
    let sections: [HomeSection]

    enum CodingKeys: String, CodingKey {
        case screenKey
        case navBar
        case backgroundColor
        case sections
    }
}

struct NavBarConfiguration: Decodable, Sendable {
    let title: String?
    let prefersLargeTitle: Bool
    let leadingItems: [NavBarItem]
    let trailingItems: [NavBarItem]

    enum CodingKeys: String, CodingKey {
        case title
        case prefersLargeTitle
        case leadingItems
        case trailingItems
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        prefersLargeTitle = try container.decodeIfPresent(Bool.self, forKey: .prefersLargeTitle) ?? true
        leadingItems = try container.decodeIfPresent([NavBarItem].self, forKey: .leadingItems) ?? []
        trailingItems = try container.decodeIfPresent([NavBarItem].self, forKey: .trailingItems) ?? []
    }
}

struct NavBarItem: Decodable, Identifiable, Sendable {
    enum Kind: String, Decodable, Sendable {
        case icon
        case text
        case button
    }

    let id: String
    let kind: Kind
    let title: String?
    let sfSymbol: String?
    let isEnabled: Bool
    let action: ComponentAction?

    enum CodingKeys: String, CodingKey {
        case id
        case kind
        case title
        case sfSymbol
        case isEnabled
        case action
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        kind = try container.decode(Kind.self, forKey: .kind)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        sfSymbol = try container.decodeIfPresent(String.self, forKey: .sfSymbol)
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? true
        action = try container.decodeIfPresent(ComponentAction.self, forKey: .action)
    }
}

struct ComponentAction: Decodable, Sendable {
    enum ActionType: String, Decodable, Sendable {
        case navigate
        case openURL
    }

    let type: ActionType
    let value: String
}

struct HomeSection: Decodable, Identifiable, Sendable {
    let id: String
    let type: SectionType
    let title: String?
    let subtitle: String?
    let layout: SectionLayout?
    let items: [HomeItem]

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case subtitle
        case layout
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let typeValue = try container.decode(String.self, forKey: .type)
        type = SectionType(rawValue: typeValue) ?? .generic
        title = try container.decodeIfPresent(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        layout = try container.decodeIfPresent(SectionLayout.self, forKey: .layout)
        let decodedItems = try container.decodeIfPresent([HomeItem].self, forKey: .items) ?? []
        items = decodedItems.filter { !$0.isUnsupported }
    }
}

struct SectionLayout: Decodable, Sendable {
    let type: LayoutType?
    let columns: Int?
    let rowGap: Double?
    let columnGap: Double?
    let itemWidth: Double?
    let gap: Double?
    let rowGapToken: String?
    let columnGapToken: String?
    let gapToken: String?
    let paddingToken: String?
}

enum SectionType: String, Decodable, Sendable {
    case hero
    case quickMenu
    case benefit
    case finance
    case insight
    case banner
    case generic
}

enum LayoutType: String, Decodable, Sendable {
    case stack
    case grid
    case carousel
}

enum HomeItem: Identifiable, Decodable, Sendable {
    case heroCard(HeroCardData)
    case quickIcon(QuickIconData)
    case featureCard(FeatureCardData)
    case financeCard(FinanceCardData)
    case insight(InsightData)
    case banner(BannerData)
    case unsupported(String)

    var id: String {
        switch self {
        case .heroCard(let data): return data.id
        case .quickIcon(let data): return data.id
        case .featureCard(let data): return data.id
        case .financeCard(let data): return data.id
        case .insight(let data): return data.id
        case .banner(let data): return data.id
        case .unsupported(let identifier): return identifier
        }
    }

    var isUnsupported: Bool {
        if case .unsupported = self { return true }
        return false
    }

    enum CodingKeys: String, CodingKey {
        case kind
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(String.self, forKey: .kind)
        switch kind {
        case "heroCard":
            let data = try container.decode(HeroCardData.self, forKey: .data)
            self = .heroCard(data)
        case "quickIcon":
            let data = try container.decode(QuickIconData.self, forKey: .data)
            self = .quickIcon(data)
        case "featureCard":
            let data = try container.decode(FeatureCardData.self, forKey: .data)
            self = .featureCard(data)
        case "financeCard":
            let data = try container.decode(FinanceCardData.self, forKey: .data)
            self = .financeCard(data)
        case "insight":
            let data = try container.decode(InsightData.self, forKey: .data)
            self = .insight(data)
        case "banner":
            let data = try container.decode(BannerData.self, forKey: .data)
            self = .banner(data)
        default:
            self = .unsupported(UUID().uuidString)
        }
    }
}

struct HeroCardData: Decodable, Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let amountText: String
    let accentText: String?
    let backgroundGradient: [String]?
    let action: ComponentAction?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        amountText = try container.decode(String.self, forKey: .amountText)
        accentText = try container.decodeIfPresent(String.self, forKey: .accentText)
        backgroundGradient = try container.decodeIfPresent([String].self, forKey: .backgroundGradient)
        action = try container.decodeIfPresent(ComponentAction.self, forKey: .action)
        id = (try container.decodeIfPresent(String.self, forKey: .id)) ?? title
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case amountText
        case accentText
        case backgroundGradient
        case action
    }
}

struct QuickIconData: Decodable, Identifiable, Sendable {
    let id: String
    let title: String
    let iconURL: URL?
    let sfSymbol: String?
    let action: ComponentAction?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .iconURL) {
            iconURL = URL(string: urlString)
        } else {
            iconURL = nil
        }
        sfSymbol = try container.decodeIfPresent(String.self, forKey: .sfSymbol)
        action = try container.decodeIfPresent(ComponentAction.self, forKey: .action)
        id = (try container.decodeIfPresent(String.self, forKey: .id)) ?? title
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case iconURL
        case sfSymbol
        case action
    }
}

struct FeatureCardData: Decodable, Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let caption: String?
    let iconName: String?
    let backgroundColor: String?
    let action: ComponentAction?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        caption = try container.decodeIfPresent(String.self, forKey: .caption)
        iconName = try container.decodeIfPresent(String.self, forKey: .iconName)
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        action = try container.decodeIfPresent(ComponentAction.self, forKey: .action)
        id = (try container.decodeIfPresent(String.self, forKey: .id)) ?? UUID().uuidString
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case caption
        case iconName
        case backgroundColor
        case action
    }
}

struct FinanceCardData: Decodable, Identifiable, Sendable {
    let id: String
    let title: String
    let valueText: String
    let description: String
    let statusText: String?
    let accentColor: String?
    let action: ComponentAction?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        valueText = try container.decode(String.self, forKey: .valueText)
        description = try container.decode(String.self, forKey: .description)
        statusText = try container.decodeIfPresent(String.self, forKey: .statusText)
        accentColor = try container.decodeIfPresent(String.self, forKey: .accentColor)
        action = try container.decodeIfPresent(ComponentAction.self, forKey: .action)
        id = (try container.decodeIfPresent(String.self, forKey: .id)) ?? UUID().uuidString
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case valueText
        case description
        case statusText
        case accentColor
        case action
    }
}

struct InsightData: Decodable, Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let accentText: String?
    let action: ComponentAction?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        accentText = try container.decodeIfPresent(String.self, forKey: .accentText)
        action = try container.decodeIfPresent(ComponentAction.self, forKey: .action)
        id = (try container.decodeIfPresent(String.self, forKey: .id)) ?? UUID().uuidString
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case accentText
        case action
    }
}

struct BannerData: Decodable, Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: URL?
    let action: ComponentAction?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .imageURL) {
            imageURL = URL(string: urlString)
        } else {
            imageURL = nil
        }
        action = try container.decodeIfPresent(ComponentAction.self, forKey: .action)
        id = (try container.decodeIfPresent(String.self, forKey: .id)) ?? UUID().uuidString
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case imageURL
        case action
    }
}

enum HomeScreenLoader {
    enum LoaderError: Error {
        case resourceNotFound(String)
    }

    static func load(resourceName: String, bundle: Bundle = .main) throws -> HomeScreen {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw LoaderError.resourceNotFound(resourceName)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(HomeScreen.self, from: data)
    }
}

// MARK: - Buildable conformances

extension HomeScreen: Buildable {
    func build(theme: DesignTheme, dispatcher: ComponentActionDispatcher) -> AnyView {
        HomeScreenView(screen: self, theme: theme, dispatcher: dispatcher).eraseToAnyView()
    }
}

extension HomeSection: Buildable {
    func build(theme: DesignTheme, dispatcher: ComponentActionDispatcher) -> AnyView {
        HomeSectionView(section: self, theme: theme, dispatcher: dispatcher).eraseToAnyView()
    }

    var hasHeader: Bool {
        let hasTitle = (title?.isEmpty == false)
        let hasSubtitle = (subtitle?.isEmpty == false)
        return hasTitle || hasSubtitle
    }

    var heroCards: [HeroCardData] {
        items.compactMap { item in
            if case let .heroCard(data) = item { return data }
            return nil
        }
    }

    var quickIcons: [QuickIconData] {
        items.compactMap { item in
            if case let .quickIcon(data) = item { return data }
            return nil
        }
    }

    var featureCards: [FeatureCardData] {
        items.compactMap { item in
            if case let .featureCard(data) = item { return data }
            return nil
        }
    }
}

extension HomeItem: Buildable {
    func build(theme: DesignTheme, dispatcher: ComponentActionDispatcher) -> AnyView {
        switch self {
        case .heroCard(let data):
            return HeroCardView(data: data, theme: theme, dispatcher: dispatcher).eraseToAnyView()
        case .quickIcon(let data):
            return QuickIconView(data: data, theme: theme, dispatcher: dispatcher).eraseToAnyView()
        case .featureCard(let data):
            return FeatureCardView(data: data, theme: theme, dispatcher: dispatcher).eraseToAnyView()
        case .financeCard(let data):
            return FinanceCardView(data: data, theme: theme, dispatcher: dispatcher).eraseToAnyView()
        case .insight(let data):
            return InsightCardView(data: data, theme: theme, dispatcher: dispatcher).eraseToAnyView()
        case .banner(let data):
            return BannerRowView(data: data, theme: theme, dispatcher: dispatcher).eraseToAnyView()
        case .unsupported:
            return EmptyView().eraseToAnyView()
        }
    }
}
