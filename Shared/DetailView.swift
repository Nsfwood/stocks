//
//  DetailView.swift
//  stocks
//
//  Created by Alexander Rohrig on 11/15/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    //@EnvironmentObject var settings: SettingsStorage
    
    @State var presentingCEO = false
    @State var presentingFilter = false
    
    var stock: Stock
    
    var body: some View {
        VStack {
            Text(stock.name ?? "nil")
            Spacer()
            // vvv only if not premium
                Text("Upgrade to Premium...")
                Button("Upgrade to Premium") { }
            Divider()
            Link("Data provided by IEX Cloud", destination: URL(string: "https://iexcloud.io")!)
                .navigationTitle(stock.name ?? "nil")
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                        Button(action: ceoInfo) { Label("Show CEO Information", systemImage: "person") }
                        Button(action: filterChart) { Label("Filter Chart", systemImage: "line.horizontal.3.decrease.circle") }
                        Button(action: favorite) {
                            if stock.isFavorite {
                                Label("Unfavorite Stock", systemImage: "star.fill").foregroundColor(.orange)
                            }
                            else {
                                Label("Favorite Stock", systemImage: "star")
                            }
                        }
                    }
                }
        }.padding()
            // vvv iOS only
//            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func ceoInfo() {
        
    }
    
    private func filterChart() {
        
    }
    
    private func favorite() {
        let context = stock.managedObjectContext
        context?.performAndWait {
            stock.isFavorite.toggle()
            do {
                try context?.save()
                print("saved favorite status to core data")
            }
            catch {
                print("unable to save favorite status to core data")
            }
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
