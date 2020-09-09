//
//  FilterPopoverView.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/30/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct FilterPopoverView: View {
    
    @EnvironmentObject var settings: SettingsStorage
//    @State private var ignorePickedYearAndIncludeAllYearsInMonthDayRange = true
//    @State private var xStart = Date()
//    @State private var xEnd = Date()
    @State private var yStart = ""
    @State private var yEnd = ""
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var body: some View {
        Form {
            Section(header: Text(Translation.FILTER_X_TITLE), footer: Text(Translation.FILTER_X_SUBTITLE)) {
                // date pickers
                DatePicker(selection: $settings.xRangeStart, displayedComponents: .date) {
                    Text(Translation.FILTER_X_START)
                }
                DatePicker(selection: $settings.xRangeEnd, displayedComponents: .date) {
                    Text(Translation.FILTER_X_END)
                }
                Toggle(isOn: $settings.includeAllYears) {
                    Text(Translation.FILTER_X_INCLUDE)
                }
                Button(Translation.FILTER_X_CLEAR) { self.settings.xRangeStart = Date(); self.settings.xRangeEnd = Date() }
            }
            Section(header: Text(Translation.FILTER_Y_TITLE)) {
                TextField(Translation.FILTER_Y_START, text: $settings.yRangeStart)
                TextField(Translation.FILTER_Y_END, text: $settings.yRangeEnd)
                Button(Translation.FILTER_Y_CLEAR) { self.settings.yRangeStart = ""; self.settings.yRangeEnd = "" }
            }
        }.frame(width: 500, height: 500)
    }
}

struct FilterPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        FilterPopoverView()
    }
}
