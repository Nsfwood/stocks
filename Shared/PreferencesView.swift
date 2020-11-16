//
//  PreferencesView.swift
//  stocks
//
//  Created by Alexander Rohrig on 11/15/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
    
    @State var userHasPremium = false
    @State var startJan1 = false
    @State var showLogos = true
    @State var showArea = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Form {
            // vvv remove in production vvv
            Toggle(isOn: $userHasPremium) { Text("TEST_PREMIUM") }
            Section(header: Text("Premium")) {
                //Text("Premium allows you to view a stock's entire price history, allows you to search by company name and fragments, allows you to save more than 3 stocks to your portfolio, and removes ads.")
                Button("Upgrade to Premium") { }
                Button("Restore Purchase") { }
            }
            #if os(iOS)
            Section(header: Text("App Icon")) {
                Text("Coming Soon")
            }
            #endif
            Section(header: Text("Graphics")) {
                Toggle(isOn: $startJan1) {
                    Text("Start Graph on January 1st")
                }
                Toggle(isOn: $showLogos) {
                    Text("Show Stock Logos")
                }
                Toggle(isOn: $showArea) {
                    Text("Show Area on Line Charts")
                }
            }
            #if os(macOS)
            Divider()
            #endif
            Section() {
                Button("Acknowledgements") { }
                Button("Help With Translationsents") { openURL(URL(string: "https://alexanderrohrig.com/translationhelp")!) }
                Button("Donate") { }
                // vvv remove in production vvv
                Text("If you downloaded this app through TestFlight, please report the bug in the TestFlight app.")
                Button("Report a Bug") { openURL(URL(string: "https://github.com/Nsfwood/stocks/issues")!) }
                Text("Made with ❤️")
            }
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
