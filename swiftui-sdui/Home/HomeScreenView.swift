//
//  HomeScreenView.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import SwiftUI

struct HomeScreenView: View {
    let screen: HomeScreen
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: theme.spacing(.xl)) {
                ForEach(screen.sections) { section in
                    section
                        .build(theme: theme, dispatcher: dispatcher)
                        .padding(.horizontal, theme.spacing(.page))
                }
            }
            .padding(.vertical, theme.spacing(.l))
        }
        .background(backgroundColor)
    }

    private var backgroundColor: Color {
        Color.hex(screen.backgroundColor, fallback: theme.colors.backgroundPrimary)
    }
}

struct HomeSectionView: View {
    let section: HomeSection
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing(.m)) {
            if section.hasHeader {
                SectionHeaderView(
                    title: section.title,
                    subtitle: section.subtitle,
                    theme: theme
                )
            }
            sectionContent
        }
    }

    @ViewBuilder
    private var sectionContent: some View {
        switch section.type {
        case .hero:
            heroContent
        case .quickMenu:
            quickMenuContent
        case .benefit:
            horizontalCards
        case .finance, .insight, .banner, .generic:
            stackContent
        }
    }

    @ViewBuilder
    private var heroContent: some View {
        let heroCards = section.heroCards
        if heroCards.count > 1 {
            TabView {
                ForEach(heroCards) { data in
                    HeroCardView(data: data, theme: theme, dispatcher: dispatcher)
                }
            }
            .frame(height: 210)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        } else if let card = heroCards.first {
            HeroCardView(data: card, theme: theme, dispatcher: dispatcher)
        } else {
            stackContent
        }
    }

    @ViewBuilder
    private var quickMenuContent: some View {
        let icons = section.quickIcons
        if icons.isEmpty {
            stackContent
        } else {
            let columns = Array(
                repeating: GridItem(.flexible(), spacing: columnSpacing),
                count: section.layout?.columns ?? 3
            )
            LazyVGrid(columns: columns, spacing: rowSpacing) {
                ForEach(icons) { item in
                    QuickIconView(data: item, theme: theme, dispatcher: dispatcher)
                }
            }
        }
    }

    @ViewBuilder
    private var horizontalCards: some View {
        let cards = section.featureCards
        if cards.isEmpty {
            stackContent
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: gapSpacing) {
                    ForEach(cards) { card in
                        FeatureCardView(data: card, theme: theme, dispatcher: dispatcher)
                            .frame(width: section.layout?.itemWidth ?? 280)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    @ViewBuilder
    private var stackContent: some View {
        VStack(spacing: rowSpacing) {
            ForEach(section.items) { item in
                item.build(theme: theme, dispatcher: dispatcher)
            }
        }
    }

    private var rowSpacing: Double {
        if let token = section.layout?.rowGapToken {
            return theme.spacing(raw: token, fallback: theme.spacing(.m))
        }
        return section.layout?.rowGap ?? theme.spacing(.m)
    }

    private var columnSpacing: Double {
        if let token = section.layout?.columnGapToken {
            return theme.spacing(raw: token, fallback: theme.spacing(.m))
        }
        return section.layout?.columnGap ?? theme.spacing(.m)
    }

    private var gapSpacing: Double {
        if let token = section.layout?.gapToken {
            return theme.spacing(raw: token, fallback: theme.spacing(.m))
        }
        return section.layout?.gap ?? theme.spacing(.m)
    }
}

private struct SectionHeaderView: View {
    let title: String?
    let subtitle: String?
    let theme: DesignTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .font(theme.typography.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.color(.labelPrimary))
            }
            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.color(.labelSecondary))
            }
        }
    }
}

private struct ComponentButton<Content: View>: View {
    let action: ComponentAction?
    let dispatcher: ComponentActionDispatcher
    let content: Content

    init(action: ComponentAction?, dispatcher: ComponentActionDispatcher, @ViewBuilder content: () -> Content) {
        self.action = action
        self.dispatcher = dispatcher
        self.content = content()
    }

    var body: some View {
        if let action {
            Button {
                dispatcher.send(action)
            } label: {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }
}

struct HeroCardView: View {
    let data: HeroCardData
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        ComponentButton(action: data.action, dispatcher: dispatcher) {
            VStack(alignment: .leading, spacing: theme.spacing(.s)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.title)
                        .font(theme.typography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.color(.labelInverseSecondary))
                    if let subtitle = data.subtitle {
                        Text(subtitle)
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.color(.labelInverseSecondary))
                    }
                }
                Text(data.amountText)
                    .font(theme.typography.heroAmount)
                    .foregroundStyle(theme.color(.labelInversePrimary))
                if let accent = data.accentText {
                    Text(accent)
                        .font(theme.typography.body)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.colors.semanticPositive)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(theme.spacing(.l))
            .background(heroBackground)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius(.l), style: .continuous))
        }
    }

    private var heroBackground: LinearGradient {
        let colors = (data.backgroundGradient?.compactMap { Color(hexString: $0) }) ?? [
            Color(hexString: "#10131C") ?? .black,
            Color(hexString: "#1C2635") ?? .black.opacity(0.7)
        ]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct QuickIconView: View {
    let data: QuickIconData
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        ComponentButton(action: data.action, dispatcher: dispatcher) {
            VStack(spacing: theme.spacing(.s)) {
                ZStack {
                    Circle()
                        .fill(theme.colors.backgroundSecondary)
                        .frame(width: 56, height: 56)
                    IconView(url: data.iconURL, systemName: data.sfSymbol)
                        .frame(width: 32, height: 32)
                }
                Text(data.title)
                    .font(theme.typography.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(theme.color(.labelPrimary))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct FeatureCardView: View {
    let data: FeatureCardData
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        ComponentButton(action: data.action, dispatcher: dispatcher) {
            VStack(alignment: .leading, spacing: theme.spacing(.s)) {
                HStack(spacing: theme.spacing(.s)) {
                    if let iconName = data.iconName {
                        Image(systemName: iconName)
                            .font(.title2)
                            .foregroundStyle(theme.color(.labelInversePrimary))
                    }
                    Spacer()
                    if let caption = data.caption {
                        Text(caption)
                            .font(theme.typography.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.color(.labelInversePrimary))
                            .padding(.horizontal, theme.spacing(.s))
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.title)
                        .font(theme.typography.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.color(.labelInversePrimary))
                    Text(data.subtitle)
                        .font(theme.typography.body)
                        .foregroundStyle(theme.color(.labelInverseSecondary))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(theme.spacing(.l))
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius(.l), style: .continuous))
        }
    }

    private var backgroundColor: Color {
        Color.hex(data.backgroundColor, fallback: theme.colors.brandPrimary)
    }
}

struct FinanceCardView: View {
    let data: FinanceCardData
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        ComponentButton(action: data.action, dispatcher: dispatcher) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.title)
                        .font(theme.typography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.color(.labelPrimary))
                    Text(data.description)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.color(.labelSecondary))
                    if let status = data.statusText {
                        Text(status)
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.color(.labelTertiary))
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(data.valueText)
                        .font(theme.typography.body)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.color(.labelPrimary))
                    if let accent = data.accentColor {
                        Circle()
                            .fill(Color.hex(accent, fallback: theme.colors.brandPrimary))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding()
            .background(theme.colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius(.m), style: .continuous))
        }
    }
}

struct InsightCardView: View {
    let data: InsightData
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        ComponentButton(action: data.action, dispatcher: dispatcher) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.title)
                        .font(theme.typography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.color(.labelPrimary))
                    Text(data.description)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.color(.labelSecondary))
                }
                Spacer()
                if let accent = data.accentText {
                    Text(accent)
                        .font(theme.typography.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.colors.brandPrimary)
                }
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(theme.color(.labelTertiary))
            }
            .padding()
            .background(theme.colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius(.m), style: .continuous))
        }
    }
}

struct BannerRowView: View {
    let data: BannerData
    let theme: DesignTheme
    let dispatcher: ComponentActionDispatcher

    var body: some View {
        ComponentButton(action: data.action, dispatcher: dispatcher) {
            HStack(spacing: theme.spacing(.m)) {
                if let url = data.imageURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(theme.colors.backgroundSecondary)
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius(.m), style: .continuous))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.title)
                        .font(theme.typography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.color(.labelPrimary))
                    if let subtitle = data.subtitle {
                        Text(subtitle)
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.color(.labelSecondary))
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(theme.color(.labelTertiary))
            }
            .padding()
            .background(theme.colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius(.m), style: .continuous))
        }
    }
}

struct IconView: View {
    let url: URL?
    let systemName: String?

    var body: some View {
        if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    PlaceholderIcon(systemName: systemName)
                @unknown default:
                    PlaceholderIcon(systemName: systemName)
                }
            }
        } else {
            PlaceholderIcon(systemName: systemName)
        }
    }

    private struct PlaceholderIcon: View {
        let systemName: String?

        var body: some View {
            if let systemName {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "square.grid.2x2.fill")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
