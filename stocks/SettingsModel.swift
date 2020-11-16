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

class SettingsStorage: ObservableObject {
    
    private enum Keys {
        static let pro = "lines.pro"
        static let icon = "lines.icon"
        static let logo = "lines.logo.stocks"
        static let graphArea = "lines.graph.area"
        static let colorSet = "lines.graph.colorset"
    }
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    let objectWillChange = PassthroughSubject<Void, Never>()
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        defaults.register(defaults: [Keys.pro: false, Keys.icon: 0])
        cancellable = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).map { _ in () }.subscribe(objectWillChange)
    }
    
    // filter
    @Published var filterXRange: Bool = false
    @Published var xRangeStart: Date = Date()
    @Published var xRangeEnd: Date = Date()
    @Published var includeAllYears: Bool = true
    @Published var yRangeStart: String = ""
    @Published var yRangeEnd: String = ""
    @Published var startChartsAtJan1 = false
//    @Published var isPro = false
    @Published var icon = 0
    @Published var stockLogo = true
    @Published var showGraphArea = false
    @Published var colorSet = 0
    @Published var canAccessInternet = true
    @Published var shouldUpdateChart = true
    @Published var savedStocks = 0
    
    var isPro: Bool {
        set { defaults.set(newValue, forKey: Keys.pro) }
        get { defaults.bool(forKey: Keys.pro) }
    }
    
}

extension SettingsStorage {
    func unlockPro() {
            
    }
    
    func restorePro() {
        
    }
}
