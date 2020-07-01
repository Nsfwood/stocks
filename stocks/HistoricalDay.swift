//
//  HistoricalDay.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/25/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import SwiftUI

struct HistoricalDay: Codable {
    
    var date: String
    var open: Double
    var close: Double // use for chart
    var uClose: Double // unadjusted
    var high: Double
    var low: Double
    var volume: Int
    var change: Double
    var changePercent: Double
    var changeOverTime: Double
    var label: String
}
