//
//  SettingsView.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/27/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStorage
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
	                Toggle(isOn: $settings.isPro) {
                    Text("TEST_USER_HAS_PREMIUM")
                }
                if !settings.isPro {
                    Section(header: Text("Premium")) {
                        Text("Premium allows you to view a stock's entire price history, allows you to search by company name and fragments, allows you to save more than 3 stocks to your portfolio, and removes ads.")
                        Button("Upgrade to a Premium Subscription") {
                            print("upgrade")
                        }
                        Button("Restore Purchase") {
                            print("upgrade")
                        }
                    }
                }
                Section(header: Text("App Icon")) {
                    Text("Coming Soon")
                }
                // TODO: maybe move to device settings
                Section(header: Text("Graphics")) {
                    Toggle(isOn: $settings.startChartsAtJan1) {
                        Text("Start Chart on January 1st")
                    }
                    Toggle(isOn: $settings.stockLogo) {
                        Text("Show Stock Logos")
                    }
                    Toggle(isOn: $settings.showGraphArea) {
                        Text("Show Area on Graph")
                    }
                    // TODO: pick chart color set
//                    Picker(selection: $settings.colorSet, label: "Chart Color Set") {
//                        ForEach(1..<2, id: \.self) {
//                            Text("Color Set")
//                        }
//                    }
                }
                Section(header: Text("Tags")) {
                    Text("Coming Soon")
                }
                // TODO: move to device settings
                Section() {
                    Text("Acknowledgements")
                }
            }.navigationBarTitle(Text(Translation.settings_Title)).navigationBarItems(trailing: Button(Translation.done_Button) { self.isPresented = false })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(isPresented: ispre)
//    }
//}
