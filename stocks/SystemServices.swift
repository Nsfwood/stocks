//
//  SystemServices.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/1/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
//import Cocoa

struct SystemServices: ViewModifier {
    static var settings = SettingsStorage()
    
    func body(content: Content) -> some View {
        content
            // services
            .environmentObject(Self.settings)
    }
}

public func openLinkInSafari(url: String) {
    let urlAsURL = URL(string: url)!
    #if os(iOS)
        UIApplication.shared.open(urlAsURL)
    #elseif os(macOS)
        NSWorkspace.shared.open(urlAsURL)
    #else
        print("running on new apple product")
    #endif
}

func getCurrencyFormat(from: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.autoupdatingCurrent
    currencyFormatter.currencySymbol = "$"
    currencyFormatter.currencyCode = "USD"
    
    return currencyFormatter.string(from: NSNumber(value: from))!
}

func getPercentFormat(from: Double) -> String {
    let percentFormatter = NumberFormatter()
    percentFormatter.usesGroupingSeparator = true
    percentFormatter.numberStyle = .percent
    percentFormatter.locale = Locale.autoupdatingCurrent
    
    return percentFormatter.string(from: NSNumber(value: from))!
}

func getDateFormat(from: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.calendar = Calendar.autoupdatingCurrent
    
    return dateFormatter.string(from: from)
}
