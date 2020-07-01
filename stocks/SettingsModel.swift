//
//  SettingsModel.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/29/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class SettingsStore: ObservableObject {
    private enum Keys {
        static let pro = "lines.pro"
        static let icon = "lines.icon"
        static let logo = "lines.logo.stocks"
        static let graphArea = "lines.graph.area"
    }
    
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [Keys.pro: false, Keys.icon: 0])
        
        cancellable = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).map { _ in () }.subscribe(objectWillChange)
    }
    
    var isPro: Bool {
        set { defaults.set(newValue, forKey: Keys.pro) }
        get { defaults.bool(forKey: Keys.pro) }
    }
    
    var icon: Int {
        set { defaults.set(newValue, forKey: Keys.icon) }
        get { defaults.integer(forKey: Keys.icon) }
    }
    
    var stockLogo: Bool {
        set { defaults.set(newValue, forKey: Keys.logo) }
        get { defaults.bool(forKey: Keys.logo) }
    }
    
    var showGraphArea: Bool {
        set { defaults.set(newValue, forKey: Keys.graphArea) }
        get { defaults.bool(forKey: Keys.graphArea) }
    }
    
}

extension SettingsStore {
    func unlockPremium() {
        // TODO: preium subscription
//        isPro = 
    }
    
    func restorePurchase() {
        // TODO: restore premium
//        isPro =
    }
}
