//
//  HomeView.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Combine
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var dispatcher = ComponentActionDispatcher()
    @State private var routePath: [AppRoute] = []
    @Environment(\.openURL) private var openURL

    private let theme = DesignTheme.toss

    var body: some View {
        NavigationStack(path: $routePath) {
            content
                .navigationTitle(navBarTitle)
                .navigationBarTitleDisplayMode(navBarDisplayMode)
                .toolbar {
                    toolbarContent
                }
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .onReceive(dispatcher.subject) { action in
            handle(componentAction: action)
        }
        .task {
            viewModel.loadHomeIfNeeded()
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if let navBar = viewModel.screen?.navBar {
            if !navBar.leadingItems.isEmpty {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    ForEach(navBar.leadingItems) { item in
                        toolbarButton(for: item)
                    }
                }
            }

            if !navBar.trailingItems.isEmpty {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ForEach(navBar.trailingItems) { item in
                        toolbarButton(for: item)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func toolbarButton(for item: NavBarItem) -> some View {
        let isDisabled = !item.isEnabled
        switch item.kind {
        case .icon:
            Button {
                trigger(action: item.action)
            } label: {
                Image(systemName: item.sfSymbol ?? "bell")
            }
            .disabled(isDisabled)
        case .text, .button:
            Button {
                trigger(action: item.action)
            } label: {
                Text(item.title ?? "Action")
            }
            .disabled(isDisabled)
        }
    }

    @ViewBuilder
    private var content: some View {
        if let screen = viewModel.screen {
            screen
                .build(theme: theme, dispatcher: dispatcher)
                .ignoresSafeArea(.container, edges: .horizontal)
        } else if let error = viewModel.errorMessage {
            VStack(spacing: theme.spacing(.m)) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                Text(error)
                    .font(theme.typography.body)
            }
            .padding()
            .foregroundStyle(theme.colors.brandPrimary)
        } else {
            ProgressView()
        }
    }

    private var navBarTitle: String {
        viewModel.screen?.navBar?.title ?? "홈"
    }

    private var navBarDisplayMode: NavigationBarItem.TitleDisplayMode {
        (viewModel.screen?.navBar?.prefersLargeTitle ?? true) ? .large : .inline
    }

    private func trigger(action: ComponentAction?) {
        guard let action else { return }
        handle(componentAction: action)
    }

    private func handle(componentAction action: ComponentAction) {
        switch action.type {
        case .openURL:
            if let url = URL(string: action.value) {
                openURL(url)
            }
        case .navigate:
            if let route = AppRoute(urlString: action.value) {
                routePath.append(route)
            } else if let url = URL(string: action.value) {
                openURL(url)
            }
        }
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .notifications:
            NotificationsView()
        case .settings:
            SettingsView()
        case .unknown(let value):
            VStack(spacing: theme.spacing(.m)) {
                Text("지원하지 않는 경로에요")
                    .font(theme.typography.title)
                Text(value)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.color(.labelSecondary))
            }
            .padding()
        }
    }
}

private struct NotificationsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.badge")
                .font(.system(size: 48))
            Text("알림센터")
                .font(.title2)
        }
        .padding()
    }
}

private struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("환경설정")) {
                Toggle("푸시 알림", isOn: .constant(true))
                Toggle("이메일 수신", isOn: .constant(false))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("설정")
    }
}

#Preview {
    HomeView()
}
