//
//  krasnoyarskApp.swift
//  Shared
//
//  Created by Alexander Rohrig on 11/15/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

@main
struct krasnoyarskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #if os(macOS)
        Settings {
            PreferencesView().padding().frame(minWidth: 300)
        }
        #endif
    }
}
