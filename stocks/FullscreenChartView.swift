//
//  FullscreenChartView.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/1/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct FullscreenChartView: View {
    
    @EnvironmentObject var settings: SettingsStorage
    @State var selectedIndexes: [Int]?
    var fullscreenStock: Stock
    
    var body: some View {
        ChartViewController(stockToFetchDataFor: fullscreenStock)
    }
}
