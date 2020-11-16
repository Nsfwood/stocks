//
//  ContentView.swift
//  Shared
//
//  Created by Alexander Rohrig on 11/15/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var settings: SettingsStorage
    @State var presentingAdd = false
    @State var presentingPreferences = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Stock.isFavorite, ascending: false), NSSortDescriptor(keyPath: \Stock.name, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Stock>

    var body: some View {
        NavigationView {
            List {
                if items.isEmpty {
                    Text("Press \(Image(systemName: "plus")) to add a stock.")
                }
                ForEach(items) { stock in
                    NavigationLink(destination: DetailView(stock: stock)) {
                        HStack {
                            // vvv if show logo = true
                            Image("logo.HOLX").resizable().scaledToFit().frame(width: 40, height: 40).clipShape(ContainerRelativeShape())
                            Text(stock.symbol ?? "nil")
                            Spacer()
                            if stock.isFavorite {
                                Image(systemName: "star.fill")
                            }
                            Text(getCurrencyFormat(from: stock.lastClosePrice))
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Stocks")
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: showPreferences) {
                        Label("Preferences", systemImage: "gear").sheet(isPresented: $presentingPreferences) { PreferencesView() }
                    }
                }
                #endif
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addItem) {
                        Label("Add Stock", systemImage: "plus").sheet(isPresented: $presentingAdd) {
                            
                        }
                    }
                }
            }
            Text("Select stock to view graph.")
        }
    }
    
    private func showPreferences() {
        self.presentingPreferences.toggle()
    }

    private func addItem() {
        self.presentingAdd.toggle()
//        withAnimation {
////            let newItem = Item(context: viewContext)
////            newItem.timestamp = Date()
//            let newItem = Stock(context: viewContext)
//            newItem.id = UUID()
//            newItem.isFavorite = false
//            newItem.lastClosePrice = 365.23
//            newItem.lastUpdated = Date()
//            newItem.lastViewed = Date()
//            newItem.logo = nil
//            newItem.name = "Nook, Inc"
//            newItem.note = "Test"
//            newItem.symbol = "NOOK"
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
