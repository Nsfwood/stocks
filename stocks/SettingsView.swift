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
    @EnvironmentObject var settings: SettingsStore
    
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
                            self.settings.unlockPremium()
                        }
                        Button("Restore Purchase") {
                            self.settings.restorePurchase()
                        }
                    }
                }
                Section(header: Text("App Icon")) {
                    Text("Coming Soon")
                }
                // TODO: maybe move to device settings
                Section(header: Text("Graphics")) {
                    Toggle(isOn: $settings.stockLogo) {
                        Text("Show Stock Logos")
                    }
                    Toggle(isOn: $settings.showGraphArea) {
                        Text("Show Area on Graph")
                    }
                }
                Section(header: Text("Tags")) {
                    Text("Coming Soon")
                }
                // TODO: move to device settings
                Section() {
                    Text("Acknowledgements")
                }
                }.navigationBarTitle(Text("Settings"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
