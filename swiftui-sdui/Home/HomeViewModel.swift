//
//  HomeViewModel.swift
//  swiftui-sdui
//
//  Created by 권민재 on 1/11/26.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var screen: HomeScreen?
    @Published private(set) var errorMessage: String?

    private var hasLoaded = false

    func loadHomeIfNeeded() {
        guard !hasLoaded else { return }
        hasLoaded = true

        do {
            screen = try HomeScreenLoader.load(resourceName: "home_toss")
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
