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

public func createPreviewStock() -> Stock {
    let previewStock = Stock()
    previewStock.name = "Nook, Inc."
    previewStock.id = UUID()
    previewStock.isFavorite = false
    previewStock.lastClosePrice = 6.2
    previewStock.note = "Wait a second..."
    previewStock.symbol = "NOOK"
    previewStock.days = NSSet(array: createDaysForPreviewStock())

    return previewStock
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

func createDaysForPreviewStock() -> [Day] {
    var dayArray = [Day]()
    let day0 = Day()
    day0.close = 5.0
    day0.date = "2020-01-07"
    dayArray.append(day0)
    
    let day1 = Day()
    day1.close = 6.0
    day1.date = "2020-01-08"
    dayArray.append(day1)
    
    let day2 = Day()
    day2.close = 7.0
    day2.date = "2020-01-09"
    dayArray.append(day2)
    
    let day3 = Day()
    day3.close = 8.0
    day3.date = "2020-01-10"
    dayArray.append(day3)
    
    let day4 = Day()
    day4.close = 9.0
    day4.date = "2020-01-11"
    dayArray.append(day4)
    
    let day5 = Day()
    day5.close = 9.5
    day5.date = "2020-01-12"
    dayArray.append(day5)
    
    let day6 = Day()
    day6.close = 4.0
    day6.date = "2019-01-07"
    dayArray.append(day6)
    
    let day7 = Day()
    day7.close = 5.0
    day7.date = "2019-01-08"
    dayArray.append(day7)
    
    let day8 = Day()
    day8.close = 7.0
    day8.date = "2019-01-09"
    dayArray.append(day8)
    
    let day9 = Day()
    day9.close = 6.0
    day9.date = "2019-01-10"
    dayArray.append(day9)
    
    let day10 = Day()
    day10.close = 6.5
    day10.date = "2019-01-11"
    dayArray.append(day10)
    
    let day11 = Day()
    day11.close = 7.0
    day11.date = "2019-01-12"
    dayArray.append(day11)
    
    let day12 = Day()
    day12.close = 5.0
    day12.date = "2018-01-07"
    dayArray.append(day12)
    
    let day13 = Day()
    day13.close = 5.5
    day13.date = "2018-01-08"
    dayArray.append(day13)
    
    let day14 = Day()
    day14.close = 6.0
    day14.date = "2018-01-09"
    dayArray.append(day14)
    
    let day15 = Day()
    day15.close = 6.5
    day15.date = "2018-01-10"
    dayArray.append(day15)
    
    let day16 = Day()
    day16.close = 7.0
    day16.date = "2018-01-11"
    dayArray.append(day16)
    
    return dayArray
}
